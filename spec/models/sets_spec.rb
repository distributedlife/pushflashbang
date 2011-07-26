require 'spec_helper'

describe Sets do
  context 'migrate_from_deck' do
    before(:each) do
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

      Idiom.count.should == 5
      IdiomTranslation.count.should == 10
      Translation.count.should == 10

      # each card should be linked to the idiom that the back of the card has
      @cards.each do |card|
        found_front = false
        found_back = false
        Translation.all.each do |translation|
          if translation.form == card.front
            found_front = true if translation.language = "Chinese (Simplified)" and translation.pronunciation = card.pronunciation
          else
            found_back = true if translation.language = "English" and translation.pronunciation.blank?
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

      found_chinese = false
      found_english1 = false
      found_english2 = false
      found_english3 = false
      Translation.all.each do |translation|

        if translation.language == "Chinese (Simplified)"
          if translation.form == cards.front and translation.pronunciation == cards.pronunciation
            found_chinese = true
          end
        end
        if translation.language == "English"
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
  end
end
