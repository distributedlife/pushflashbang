# -*- encoding : utf-8 -*-
require 'spec_helper'

describe LanguagesHelper do
  before(:each) do
    @user = User.make!
    @language = Language.make!
  end

  describe 'language_is_valid?' do
    it 'should return true if language exists' do
      language_is_valid?(@language.id).should be true
    end

    it 'should reutrn false if language does not exist' do
      language_is_valid?(@language.id + 1).should be false
    end
  end

  describe 'language_is_valid_for_user?' do
    before(:each) do
      UserLanguages.make!(:user_id => @user.id, :language_id => @language.id)
    end
    
    it 'should return false if user is learning language' do
      language_is_valid_for_user?(@language.id, @user.id).should be false
    end

    it 'should return true if the user is not learning the language' do
      language_is_valid_for_user?(@language.id, @user.id + 1).should be true
    end

    it 'should return false if the language does not exist' do
      language_is_valid_for_user?(@language.id + 1, @user.id).should be false
    end

    it 'should return false if the language is disabled' do
      @language.disable!
      
      language_is_valid_for_user?(@language.id, @user.id + 1).should be false
    end
  end

  describe 'user_is_learning_language?' do
    before(:each) do
      UserLanguages.make!(:user_id => @user.id, :language_id => @language.id)
    end

    it 'should return true if user is learning language' do
      LanguagesHelper::user_is_learning_language?(@language.id, @user.id).should be true
    end

    it 'should return false if the user is not learning the language' do
      LanguagesHelper::user_is_learning_language?(@language.id, @user.id + 1).should be false
    end
  end

  describe 'merge_languages' do
    before(:each) do
      @l1 = Language.make!
      @l2 = Language.make!
    end

    it 'should disable the merged_language' do
      merge_languages @l1.id, @l2.id

      @l2.reload
      @l2.enabled?.should == false
    end
    
    it 'should merge all user native languages' do
      @user.native_language_id = @l2.id
      @user.save!

      merge_languages @l1.id, @l2.id

      @user.reload
      @user.native_language_id.should == @l1.id
    end
    
    it 'should merge all user languages' do
      ul = UserLanguages.make!(:language_id => @l2.id)

      merge_languages @l1.id, @l2.id

      ul.reload
      ul.language_id.should == @l1.id
    end

    it 'should merge all user sets' do
      us = UserSets.make!(:language_id => @l2.id)

      merge_languages @l1.id, @l2.id

      us.reload
      us.language_id.should == @l1.id
    end

    it 'should merge all translations' do
      t = Translation.make!(:language_id => @l2.id)

      merge_languages @l1.id, @l2.id

      t.reload
      t.language_id.should == @l1.id
    end

    it 'should rebuild related translations' do
      idiom = Idiom.make!
      @t1 = Translation.make!(:idiom_id => idiom.id, :language_id => @l1.id)
      @t2 = Translation.make!(:idiom_id => idiom.id, :language_id => @l1.id)
      @t3 = Translation.make!(:idiom_id => idiom.id, :language_id => @l2.id)

      RelatedTranslations.make!(:translation1_id => @t1.id, :translation2_id => @t2.id, :share_meaning => true, :share_written_form => false, :share_audible_form => false)
      RelatedTranslations.make!(:translation1_id => @t2.id, :translation2_id => @t1.id, :share_meaning => true, :share_written_form => false, :share_audible_form => false)
      RelatedTranslations.count.should == 2

      merge_languages @l1.id, @l2.id

      RelatedTranslations.count.should == 6
      RelatedTranslations.where(:translation1_id => @t1.id, :translation2_id => @t2.id).count.should == 1
      RelatedTranslations.where(:translation1_id => @t2.id, :translation2_id => @t1.id).count.should == 1

      RelatedTranslations.where(:translation1_id => @t1.id, :translation2_id => @t3.id).count.should == 1
      RelatedTranslations.where(:translation1_id => @t3.id, :translation2_id => @t1.id).count.should == 1

      RelatedTranslations.where(:translation1_id => @t2.id, :translation2_id => @t3.id).count.should == 1
      RelatedTranslations.where(:translation1_id => @t3.id, :translation2_id => @t2.id).count.should == 1
    end

    it 'should merge all user idiom schedules' do
      uis = UserIdiomSchedule.make!(:language_id => @l2.id)

      merge_languages @l1.id, @l2.id

      uis.reload
      uis.language_id.should == @l1.id
    end

    it 'should deal with multiple user idiom schedules' do
      uis1 = UserIdiomSchedule.make!(:idiom_id => 1, :user_id => 1, :language_id => @l1.id)
      uis2 = UserIdiomSchedule.make!(:idiom_id => 1, :user_id => 1, :language_id => @l2.id) #delete
      uis3 = UserIdiomSchedule.make!(:idiom_id => 1, :user_id => 2, :language_id => @l2.id) #migrate
      uis4 = UserIdiomSchedule.make!(:idiom_id => 2, :user_id => 1, :language_id => @l2.id) #migrate
      UserIdiomSchedule.count.should == 4

      merge_languages @l1.id, @l2.id

      UserIdiomSchedule.count.should == 3
      UserIdiomSchedule.where(:idiom_id => 1, :user_id => 1, :language_id => @l1.id).count.should == 1
      UserIdiomSchedule.where(:idiom_id => 1, :user_id => 1, :language_id => @l2.id).count.should == 0
      UserIdiomSchedule.where(:idiom_id => 2, :user_id => 1, :language_id => @l1.id).count.should == 1
      UserIdiomSchedule.where(:idiom_id => 1, :user_id => 2, :language_id => @l1.id).count.should == 1
      UserIdiomSchedule.where(:idiom_id => 2, :user_id => 1, :language_id => @l2.id).count.should == 0
      UserIdiomSchedule.where(:idiom_id => 1, :user_id => 2, :language_id => @l2.id).count.should == 0
    end

    it 'should delete user idiom due items associated with deleted user idiom schedules' do
      uis1 = UserIdiomSchedule.make!(:idiom_id => 1, :user_id => 1, :language_id => @l1.id)
      uis2 = UserIdiomSchedule.make!(:idiom_id => 1, :user_id => 1, :language_id => @l2.id) #delete
      UserIdiomDueItems.make!(:user_idiom_schedule_id => uis1.id)
      UserIdiomDueItems.make!(:user_idiom_schedule_id => uis2.id)
      UserIdiomSchedule.count.should == 2 
      UserIdiomDueItems.count.should == 2

      merge_languages @l1.id, @l2.id

      UserIdiomSchedule.count.should == 1
      UserIdiomSchedule.where(:idiom_id => 1, :user_id => 1, :language_id => @l1.id).count.should == 1
      UserIdiomSchedule.where(:idiom_id => 1, :user_id => 1, :language_id => @l2.id).count.should == 0
      UserIdiomDueItems.count.should == 1
      UserIdiomDueItems.where(:user_idiom_schedule_id => uis1.id).empty?.should == false
      UserIdiomDueItems.where(:user_idiom_schedule_id => uis2.id).empty?.should == true
    end

    it 'should merge all user idiom reviews' do
      uir = UserIdiomReview.make!(:language_id => @l2.id, :success => false)

      merge_languages @l1.id, @l2.id

      uir.reload
      uir.language_id.should == @l1.id
    end
  end
end
