require 'spec_helper'

describe Sets do
  context 'migrate_from_deck' do
    before(:each) do
      @user = User.make
      @set = Sets.make

      @deck = Deck.make
      @cards = []
      5.times do
        @cards << Card.make(:deck_id => @deck.id)
      end
    end

    it 'should require a valid deck' do
      assert_raise(ActiveRecord::RecordNotFound){@set.migrate_from_deck(@deck.id + 1)}
    end

    it 'should create two translations pre card and link as an idiom' do
      @set.migrate_from_deck(@deck.id)

      chinese = Language.where(:name => "Chinese (Simplified)").first
      english = Language.where(:name => "English").first

      Idiom.count.should == 5
      IdiomTranslation.count.should == 10
      Translation.count.should == 10

      # each card should be linked to the idiom that the back of the card has
      @cards.each do |card|
        found_front = false
        found_back = false
        Translation.all.each do |translation|
          if translation.form == card.front
            found_front = true if translation.language_id == chinese.id and translation.pronunciation == card.pronunciation
          else
            found_back = true if translation.language_id == english.id and translation.pronunciation.blank?
          end
        end

        found_front.should be true
        found_back.should be true
      end
    end

    it 'should split commas in the back of the card and create separate translations for each' do
      Card.delete_all
      cards = Card.make(:deck_id => @deck.id, :front => "hello, there", :back => "one, two , three")

      @set.migrate_from_deck(@deck.id)

      Idiom.count.should == 1
      IdiomTranslation.count.should == 4
      Translation.count.should == 4

      chinese = Language.where(:name => "Chinese (Simplified)").first
      english = Language.where(:name => "English").first

      found_chinese = false
      found_english1 = false
      found_english2 = false
      found_english3 = false
      Translation.all.each do |translation|
        if translation.language_id == chinese.id
          if translation.form == cards.front and translation.pronunciation == cards.pronunciation
            found_chinese = true
          end
        end

        if translation.language_id == english.id
          if translation.form == "one" and translation.pronunciation.blank?
            found_english1 = true
          end
          if translation.form == "two" and translation.pronunciation.blank?
            found_english2 = true
          end
          if translation.form == "three" and translation.pronunciation.blank?
            found_english3 = true
          end
        end
      end
      
      found_chinese.should be true
      found_english1.should be true
      found_english2.should be true
      found_english3.should be true
    end

    it 'should link all created idioms to the set' do
      @set.migrate_from_deck(@deck.id)

      Idiom.all.each do |idiom|
        SetTerms.where(:term_id => idiom.id).each do |set_term|
          set_term.set_id.should == @set.id
        end
      end
    end

    it 'should assign chapters for idioms based on cards' do
      5.times do |i|
        @cards << Card.make(:deck_id => @deck.id, :chapter => i + 1)
      end

      @set.migrate_from_deck(@deck.id)

      Card.all.each do |card|
        Translation.where(:form => card.front).each do |translation|
          IdiomTranslation.where(:translation_id => translation.id).each do |idiom_translation|
            SetTerms.where(:term_id => idiom_translation.idiom_id).each do |set_term|
              set_term.chapter.should == card.chapter
            end
          end
        end

        Translation.where(:form => card.back).each do |translation|
          IdiomTranslation.where(:translation_id => translation.id).each do |idiom_translation|
            SetTerms.where(:term_id => idiom_translation.idiom_id).each do |set_term|
              set_term.chapter.should == card.chapter
            end
          end
        end
      end
    end

    it 'should assigned cards position pased on order of creation' do
      @set.migrate_from_deck(@deck.id)

      Card.order(:id).all.each_with_index do |card, i|
        Translation.where(:form => card.front).each do |translation|
          IdiomTranslation.where(:translation_id => translation.id).each do |idiom_translation|
            SetTerms.where(:term_id => idiom_translation.idiom_id).each do |set_term|
              set_term.position.should == i + 1
            end
          end
        end
      end
    end

    describe 'migrating reviews' do
      it 'should create an idiom review for each card review' do
        review = UserCardReview.make(:user_id => @user.id, :card_id => @cards.first.id,
          :due => 5.days.ago, :review_start => 4.days.ago, :reveal => 3.days.ago,	:result_recorded => 2.days.ago,
           :interval => 5, :review_type => 1)

        UserCardReview.count.should == 1
        
        @set.migrate_from_deck(@deck.id)

        UserIdiomReview.count.should == 1
        user_idiom_review = UserIdiomReview.first
        user_idiom_review.user_id.should == review.user_id
        user_idiom_review.due.should == review.due
        user_idiom_review.review_start.should == review.review_start
        user_idiom_review.reveal.should == review.reveal
        user_idiom_review.interval.should == review.interval
        user_idiom_review.review_type.should == review.review_type

        t = Translation.where(:form => @cards.first.front)

        user_idiom_review.idiom_id.should == IdiomTranslation.where(:translation_id => t.first.id).first.idiom_id
        user_idiom_review.language_id.should == Language::get_or_create("Chinese (Simplified)").id
      end

      it 'should map a result of didnt_know to failure' do
        UserCardReview.make(:user_id => @user.id, :card_id => @cards.first.id,
          :result_success => 'didnt_know', :review_type => 1)

        @set.migrate_from_deck(@deck.id)

        UserIdiomReview.first.success.should == false
      end

      it 'should map a result of partial_correct to failure' do
        UserCardReview.make(:user_id => @user.id, :card_id => @cards.first.id,
          :result_success => 'partial_correct', :review_type => 1)

        @set.migrate_from_deck(@deck.id)

        UserIdiomReview.first.success.should == false
      end

      it 'should map a result of shaky_good to success' do
        UserCardReview.make(:user_id => @user.id, :card_id => @cards.first.id,
          :result_success => 'shaky_good', :review_type => 1)

        @set.migrate_from_deck(@deck.id)

        UserIdiomReview.first.success.should == true
      end

      it 'should map a result of good to success' do
        UserCardReview.make(:user_id => @user.id, :card_id => @cards.first.id,
          :result_success => 'good', :review_type => 1)

        @set.migrate_from_deck(@deck.id)

        UserIdiomReview.first.success.should == true
      end
    end

    describe 'migrating schedules' do
      it 'should migrate a schedule for each card schedule' do
        old_schedule = UserCardSchedule.create(:user_id => @user.id, :card_id => @cards.first.id, :due => 5.days.ago, :interval => 36)

        UserCardSchedule.count.should == 1

        @set.migrate_from_deck(@deck.id)

        UserIdiomSchedule.count.should == 1
        new_schedule = UserIdiomSchedule.first
        new_schedule.user_id.should == old_schedule.user_id

        t = Translation.where(:form => @cards.first.front)

        new_schedule.idiom_id.should == IdiomTranslation.where(:translation_id => t.first.id).first.idiom_id
        new_schedule.language_id.should == Language::get_or_create("Chinese (Simplified)").id
      end

      it 'should create a due item for each review type for the user for the card' do
        old_schedule = UserCardSchedule.create(:user_id => @user.id, :card_id => @cards.first.id, :due => 5.days.ago, :interval => 36)

        review1 = UserCardReview.make(:user_id => @user.id, :card_id => @cards.first.id, :review_type => 1)
        review2 = UserCardReview.make(:user_id => @user.id, :card_id => @cards.first.id, :review_type => 32)


        @set.migrate_from_deck(@deck.id)

        UserIdiomSchedule.count.should == 1
        UserIdiomDueItems.count.should == 2
        review_types = [review1.review_type, review2.review_type]
        review_types_matched = []
        UserIdiomDueItems.all.each do |due_item|
          due_item.due.utc.should == old_schedule.due.utc
          due_item.interval.should == old_schedule.interval

          if [due_item.review_type] & review_types_matched == [due_item.review_type]
            raise 'Due item not mapped correctly'
          end
          if [due_item.review_type] & review_types == [due_item.review_type]
            review_types_matched << due_item.review_type
          end
        end
      end
    end
  end
end
