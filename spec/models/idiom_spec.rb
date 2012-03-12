# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Idiom do
  describe 'translations_in_idiom_and_language' do
    before(:each) do
      @english = Language.make!
      @chinese = Language.make!
      @spanish = Language.make!

      @idiom = Idiom.create
      @translation1 = Translation.create(:idiom_id => @idiom.id, :language_id => @english.id, :form => "a")
      @translation2 = Translation.create(:idiom_id => @idiom.id, :language_id => @chinese.id, :form => "b")
      @translation3 = Translation.create(:idiom_id => @idiom.id, :language_id => @chinese.id, :form => "c")
    end

    it 'should return an empty set if no translations are in the language' do
      Idiom::translations_in_idiom_and_language(@idiom.id, @spanish.id).should == []
    end

    it 'should return the translations that share the language' do
      Idiom::translations_in_idiom_and_language(@idiom.id, @english.id).should == [@translation1]
      Idiom::translations_in_idiom_and_language(@idiom.id, @chinese.id).should == [@translation2, @translation3]
    end
  end

  describe 'exists?' do
    it 'should return true if the idiom exists' do
      Idiom::exists?(Idiom.make!.id).should == true
    end

    it 'should return false if the idiom does not exist' do
      Idiom::exists?(100).should == false
    end
  end

  describe 'get_from_translations' do
    before(:each) do
      @idiom = Idiom.make!
      @idiom2 = Idiom.make!
      @t = Translation.make!(:idiom_id => @idiom.id)
      @t2 = Translation.make!(:idiom_id => @idiom2.id)
      @t3 = Translation.make!(:idiom_id => @idiom2.id)
    end

    it 'should return the idiom refered by the translation' do
      result = Idiom::get_from_translations @t

      result.count.should == 1

      result.should == [@idiom]
    end

    it 'should return the idioms refered by multiple translations' do
      result = Idiom::get_from_translations [@t, @t2]

      result.count.should == 2

      result.should == [@idiom, @idiom2]
    end
    
    it 'should accept translation ids' do
      result = Idiom::get_from_translations @t.id

      result.count.should == 1

      result.should == [@idiom]
    end

    it 'should accept translation objects' do
      result = Idiom::get_from_translations @t

      result.count.should == 1

      result.should == [@idiom]
    end

    it 'should return each idiom only once' do
      result = Idiom::get_from_translations [@t, @t2, @t3]

      result.count.should == 2

      result.should == [@idiom, @idiom2]
    end
  end

  describe 'merge_into' do
    before(:each) do
      @set1 = Sets.make!
      @set2 = Sets.make!
      @idiom1 = Idiom.make!
      @idiom2 = Idiom.make!
      @set1.add_term @idiom1.id
      @set2.add_term @idiom2.id

      @t1 = Translation.make!(:idiom_id => @idiom1.id)
      @t2 = Translation.make!(:idiom_id => @idiom2.id)
      @t3 = Translation.make!(:idiom_id => @idiom2.id)
    end

    it 'should move all translation into the new idiom' do
      @idiom2.merge_into @idiom1.id

      @t1.reload
      @t2.reload
      @t3.reload
      @t1.idiom_id.should == @idiom1.id
      @t2.idiom_id.should == @idiom1.id
      @t3.idiom_id.should == @idiom1.id
    end

    it 'should move all set terms into the new idiom' do
      @idiom2.merge_into @idiom1.id

      @set1.set_terms.reload
      @set2.set_terms.reload

      @set1.set_terms.count.should == 1
      @set1.set_terms.first.term_id.should == @idiom1.id
      @set2.set_terms.count.should == 1
      @set2.set_terms.first.term_id.should == @idiom1.id
    end

    it 'should not created duplicate set terms' do
      SetTerms.where(:term_id => @idiom2.id).each {|st| st.set_id = @set1.id; st.save}
      @set1.set_terms.count.should == 2

      @idiom2.merge_into @idiom1.id

      @set1.set_terms.reload

      @set1.set_terms.count.should == 1
      @set1.set_terms.first.term_id.should == @idiom1.id
    end

    it 'should move all user idiom schedules into the new idiom' do
      UserIdiomSchedule.make!(:idiom_id => @idiom1.id, :user_id => 1)
      UserIdiomSchedule.make!(:idiom_id => @idiom2.id, :user_id => 2)

      @idiom2.merge_into @idiom1.id

      UserIdiomSchedule.count.should == 2
      UserIdiomSchedule.first.idiom_id.should == @idiom1.id
      UserIdiomSchedule.last.idiom_id.should == @idiom1.id
    end

    it 'should not create duplicate user idiom schedules' do
      UserIdiomSchedule.make!(:idiom_id => @idiom1.id, :user_id => 1, :language_id => 1)
      UserIdiomSchedule.make!(:idiom_id => @idiom2.id, :user_id => 1, :language_id => 1)

      @idiom2.merge_into @idiom1.id

      UserIdiomSchedule.count.should == 1
      UserIdiomSchedule.first.idiom_id.should == @idiom1.id
    end

    it 'will not merge duplicates unless identical' do
      UserIdiomSchedule.make!(:idiom_id => @idiom1.id, :user_id => 1, :language_id => 1)
      UserIdiomSchedule.make!(:idiom_id => @idiom2.id, :user_id => 2, :language_id => 1)
      UserIdiomSchedule.make!(:idiom_id => @idiom2.id, :user_id => 1, :language_id => 2)

      @idiom2.merge_into @idiom1.id

      UserIdiomSchedule.count.should == 3
    end

    it 'should move all user idiom reviews into the new idiom' do
      UserIdiomReview.make!(:idiom_id => @idiom1.id)
      UserIdiomReview.make!(:idiom_id => @idiom2.id)
      UserIdiomReview.count.should == 2

      @idiom2.merge_into @idiom1.id

      @idiom2.merge_into @idiom1.id
      UserIdiomReview.where(:idiom_id => @idiom1.id).count.should == 2
      UserIdiomReview.where(:idiom_id => @idiom2.id).count.should == 0
    end

    describe 'when merging due items' do
      it 'merge due items that have the same review type and use the next "due" item' do
        uis1 = UserIdiomSchedule.make!(:idiom_id => @idiom1.id)
        uis2 = UserIdiomSchedule.make!(:idiom_id => @idiom2.id)

        day_from_now = 1.day.from_now
        day_ago = 1.day.ago

        UserIdiomReview::REVIEW_TYPES.each_with_index do |rt, index|
          UserIdiomDueItems.make!(:user_idiom_schedule_id => uis1.id, :review_type => rt, :due => index % 2 == 0 ? day_from_now : day_ago)
          UserIdiomDueItems.make!(:user_idiom_schedule_id => uis2.id, :review_type => rt, :due => index % 2 == 0 ? day_ago : day_from_now)
        end
        UserIdiomDueItems.count.should == 12
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::READING).first.due.should == day_from_now
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::WRITING).first.due.should == day_ago
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::TYPING).first.due.should == day_from_now
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::HEARING).first.due.should == day_ago
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::SPEAKING).first.due.should == day_from_now
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::TRANSLATING).first.due.should == day_ago
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis2.id, :review_type => UserIdiomReview::READING).first.due.should == day_ago
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis2.id, :review_type => UserIdiomReview::WRITING).first.due.should == day_from_now
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis2.id, :review_type => UserIdiomReview::TYPING).first.due.should == day_ago
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis2.id, :review_type => UserIdiomReview::HEARING).first.due.should == day_from_now
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis2.id, :review_type => UserIdiomReview::SPEAKING).first.due.should == day_ago
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis2.id, :review_type => UserIdiomReview::TRANSLATING).first.due.should == day_from_now



        @idiom2.merge_into @idiom1.id


        
        UserIdiomDueItems.count.should == 6
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis2.id).count.should == 0
        
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::READING).count.should == 1
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::READING).first.due.should == day_from_now
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::WRITING).count.should == 1
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::WRITING).first.due.should == day_from_now
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::TYPING).count.should == 1
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::TYPING).first.due.should == day_from_now
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::HEARING).count.should == 1
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::HEARING).first.due.should == day_from_now
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::SPEAKING).count.should == 1
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::SPEAKING).first.due.should == day_from_now
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::TRANSLATING).count.should == 1
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::TRANSLATING).first.due.should == day_from_now
      end

      it 'should use the only option if there is only one option' do
        uis1 = UserIdiomSchedule.make!(:idiom_id => @idiom1.id)
        uis2 = UserIdiomSchedule.make!(:idiom_id => @idiom2.id)

        UserIdiomReview::REVIEW_TYPES.each_with_index do |rt, index|
          if index % 2 == 0
            UserIdiomDueItems.make!(:user_idiom_schedule_id => uis1.id, :review_type => rt)
          else
            UserIdiomDueItems.make!(:user_idiom_schedule_id => uis2.id, :review_type => rt)
          end
        end
        UserIdiomDueItems.count.should == 6
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::READING).count.should == 1
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::TYPING).count.should == 1
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::SPEAKING).count.should == 1
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis2.id, :review_type => UserIdiomReview::WRITING).count.should == 1
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis2.id, :review_type => UserIdiomReview::HEARING).count.should == 1
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis2.id, :review_type => UserIdiomReview::TRANSLATING).count.should == 1



        @idiom2.merge_into @idiom1.id


        
        UserIdiomDueItems.count.should == 6
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis2.id).count.should == 0

        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::READING).count.should == 1
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::TYPING).count.should == 1
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::SPEAKING).count.should == 1
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::WRITING).count.should == 1
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::HEARING).count.should == 1
        UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id, :review_type => UserIdiomReview::TRANSLATING).count.should == 1
      end
    end

    it 'should remove duplicate translations' do
      @t2.form = @t1.form
      @t2.pronunciation = @t1.pronunciation
      @t2.language_id = @t1.language_id
      @t2.save

      Translation.count.should == 3

      
      @idiom2.merge_into @idiom1.id


      Translation.count.should == 2
      @t1.reload
      @t3.reload
      @t1.idiom_id.should == @idiom1.id
      @t3.idiom_id.should == @idiom1.id
    end

    it 'should delete the now merged idiom' do
      Idiom.count.should == 2

      @idiom2.merge_into @idiom1.id

      Idiom.count.should == 1
      Idiom.first.should == @idiom1
    end
  end
end
