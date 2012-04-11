# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UserSets do
  context 'to be valid' do
    it 'should have a user_id' do
      user_card_review = UserSets.new(:set_id => 2, :language_id => 1, :chapter => 1)
      user_card_review.valid?.should == false
      user_card_review.user_id = 1
      user_card_review.valid?.should == true
    end

    it 'should have a set_id' do
      user_card_review = UserSets.new(:user_id => 1, :language_id => 1, :chapter => 1)
      user_card_review.valid?.should == false
      user_card_review.set_id = 1
      user_card_review.valid?.should == true
    end

    it 'should have a language_id' do
      user_card_review = UserSets.new(:user_id => 1, :set_id => 2, :chapter => 1)
      user_card_review.valid?.should == false
      user_card_review.language_id = 1
      user_card_review.valid?.should == true
    end

    it 'should have a chapter' do
      user_card_review = UserSets.new(:user_id => 1, :language_id => 1, :set_id => 2)
      user_card_review.valid?.should == false
      user_card_review.chapter = 1
      user_card_review.valid?.should == true
    end

    it 'should have a chapter greater than or equal to 1' do
      user_card_review = UserSets.new(:user_id => 1, :set_id => 2, :language_id => 1, :chapter => 0)
      user_card_review.valid?.should == false
      user_card_review.chapter = 1
      user_card_review.valid?.should == true
    end
  end

  describe 'get_for_user_and_set_where_learning_language' do
    before(:each) do
      @user = User.make!
      @set = Sets.make!
      @language = Language.make!
      UserLanguages.create(:user_id => @user.id, :language_id => @language.id)
      @a = UserSets.create(:user_id => @user.id, :set_id => @set.id, :language_id => @language.id, :chapter => 1)
    end

    it 'should return records the user has as a goal' do
      result = UserSets::get_for_user_and_set_where_learning_language @user.id, @set.id

      result.count.should == 1
      result.first.should == @a
    end

    it 'should not return records for other users' do
      user2 = User.create
      UserLanguages.create(:user_id => user2.id, :language_id => @language.id)
      UserSets.create(:user_id => user2.id, :set_id => @set.id, :language_id => @language.id)

      result = UserSets::get_for_user_and_set_where_learning_language @user.id, @set.id

      result.count.should == 1
      result.first.should == @a
    end

    it 'should not return records where the user is no longer learning the language' do
      UserLanguages.delete_all

      result = UserSets::get_for_user_and_set_where_learning_language @user.id, @set.id

      result.count.should == 0
    end
  end

  context 'due_count' do
    before(:each) do
      CardTiming.create(:seconds => 5)
      @language = Language.make!   #primary language to learn
      @language2 = Language.make!  #user native language
      @set = Sets.make!            #primary set
      @user = User.make!(:native_language_id => @language2.id)

      UserLanguages.make!(:user_id => @user.id, :language_id => @language.id)
      UserSets.make!(:user_id => @user.id, :set_id => @set.id, :language_id => @language.id, :chapter => 1)

      @idiom1 = Idiom.make!
      t1 = Translation.make!(:idiom_id => @idiom1.id, :language_id => @language.id)
      SetTerms.make!(:set_id => @set.id, :term_id => @idiom1.id, :position => 1, :chapter => 1)

      @schedule = UserIdiomSchedule.create(:idiom_id => @idiom1.id, :language_id => @language.id, :user_id => @user.id)
      UserIdiomDueItems.create(:user_idiom_schedule_id => @schedule.id, :review_type => 1, :due => 1.day.ago, :interval => 5)
      UserIdiomDueItems.create(:user_idiom_schedule_id => @schedule.id, :review_type => 16, :due => 1.day.from_now, :interval => 5)
    end

    it 'should return the due count' do
      user_set = get_first UserSets.where(:user_id => @user.id, :set_id => @set.id, :language_id => @language.id)
      user_set.due_count([1,16]).should == 1
    end

    it 'should not include due items for different review modes' do
      user_set = get_first UserSets.where(:user_id => @user.id, :set_id => @set.id, :language_id => @language.id)
      user_set.due_count([16]).should == 0
    end
  end

  context 'remaining_in_chapter' do
    before(:each) do
      @set = Sets.make!
      
      @language = Language.make!
      @language_being_learned = Language.make!
      @other_language = Language.make!
      
      #users
      @user = User.make!(:native_language_id => @language.id)
      @other_user = User.make!
       
      #idioms
      @not_reviewed = Idiom.make!
      Translation.make!(:idiom_id => @not_reviewed.id, :language_id => @language.id)
      Translation.make!(:idiom_id => @not_reviewed.id, :language_id => @language_being_learned.id)
      @reviewed = Idiom.make!
      Translation.make!(:idiom_id => @reviewed.id, :language_id => @language.id)
      Translation.make!(:idiom_id => @reviewed.id, :language_id => @language_being_learned.id)
      @not_reviewed_diff_user_reviewed = Idiom.make!
      Translation.make!(:idiom_id => @not_reviewed_diff_user_reviewed.id, :language_id => @language.id)
      Translation.make!(:idiom_id => @not_reviewed_diff_user_reviewed.id, :language_id => @language_being_learned.id)
      @not_reviewed_other_lang = Idiom.make!
      Translation.make!(:idiom_id => @not_reviewed_other_lang.id, :language_id => @language.id)
      Translation.make!(:idiom_id => @not_reviewed_other_lang.id, :language_id => @other_language.id)
 
      #idiom reviews
      @uis_reviewed = UserIdiomSchedule.make!(:user_id => @user.id, :idiom_id => @reviewed.id, :language_id => @language.id)
      UserIdiomDueItems.make!(:user_idiom_schedule_id => @uis_reviewed.id, :review_type => 1);
      @uis_other_user = UserIdiomSchedule.make!(:user_id => @other_user.id, :idiom_id => @not_reviewed_diff_user_reviewed.id, :language_id => @language.id)
      UserIdiomDueItems.make!(:user_idiom_schedule_id => @uis_other_user.id);
      
      #add each idiom to the set
      SetTerms.make!(:set_id => @set.id, :term_id => @not_reviewed.id)
      SetTerms.make!(:set_id => @set.id, :term_id => @reviewed.id)
      SetTerms.make!(:set_id => @set.id, :term_id => @not_reviewed_diff_user_reviewed.id)
      SetTerms.make!(:set_id => @set.id, :term_id => @not_reviewed_other_lang.id)
      
      #add each user to the set
      @user_set = UserSets.make!(:user_id => @user.id, :set_id => @set.id, :language_id => @language_being_learned.id)
      UserSets.make!(:user_id => @other_user.id, :set_id => @set.id, :language_id => @language_being_learned.id)
    end

    it 'should exclude those that dont match the language' do
      @user_set.remaining_in_chapter([1]).should == 2
      @user_set.remaining_in_chapter([16]).should == 3
    end

    it 'should count partial sets as reviewed' do
      @user_set.remaining_in_chapter([1,16]).should == 2
    end

    it 'should exclude items in subsequent chapters' do
      subsequent_chapter = Idiom.make!
      Translation.make!(:idiom_id => subsequent_chapter.id, :language_id => @language.id)
      Translation.make!(:idiom_id => subsequent_chapter.id, :language_id => @language_being_learned.id)
      SetTerms.make!(:set_id => @set.id, :term_id => subsequent_chapter.id, :chapter => 2)
      
      @user_set.remaining_in_chapter([1]).should == 2
    end
  end

  context 'remaining_in_set' do
    before(:each) do
      @set = Sets.make!
      
      @language = Language.make!
      @language_being_learned = Language.make!
      @other_language = Language.make!
      
      #users
      @user = User.make!(:native_language_id => @language.id)
      @other_user = User.make!
       
      #idioms
      @not_reviewed = Idiom.make!.tap do |idiom|
        Translation.make!(:idiom_id => idiom.id, :language_id => @language.id)
        Translation.make!(:idiom_id => idiom.id, :language_id => @language_being_learned.id)
        
        SetTerms.make!(:set_id => @set.id, :term_id => idiom.id)
      end
      
      @reviewed = Idiom.make!.tap do |idiom|
        Translation.make!(:idiom_id => idiom.id, :language_id => @language.id)
        Translation.make!(:idiom_id => idiom.id, :language_id => @language_being_learned.id)
        
        UserIdiomSchedule.make!(:user_id => @user.id, :idiom_id => idiom.id, :language_id => @language.id).tap do |schedule|
          UserIdiomDueItems.make!(:user_idiom_schedule_id => schedule.id, :review_type => 1);
        end
        
        SetTerms.make!(:set_id => @set.id, :term_id => idiom.id)
      end
      
      @not_reviewed_diff_user_reviewed = Idiom.make!.tap do |idiom|
        Translation.make!(:idiom_id => idiom.id, :language_id => @language.id)
        Translation.make!(:idiom_id => idiom.id, :language_id => @language_being_learned.id)
        
        UserIdiomSchedule.make!(:user_id => @other_user.id, :idiom_id => idiom.id, :language_id => @language.id).tap do |schedule|
          UserIdiomDueItems.make!(:user_idiom_schedule_id => schedule.id);
        end
        
        SetTerms.make!(:set_id => @set.id, :term_id => idiom.id)
      end
      
      @not_reviewed_other_lang = Idiom.make!.tap do |idiom|
        Translation.make!(:idiom_id => idiom.id, :language_id => @language.id)
        Translation.make!(:idiom_id => idiom.id, :language_id => @other_language.id)
        
        SetTerms.make!(:set_id => @set.id, :term_id => idiom.id)
      end
      
      
      #add each user to the set
      @user_set = UserSets.make!(:user_id => @user.id, :set_id => @set.id, :language_id => @language_being_learned.id)
      UserSets.make!(:user_id => @other_user.id, :set_id => @set.id, :language_id => @language_being_learned.id)
    end

    it 'should exclude those that dont match the language' do
      @user_set.remaining_in_set([1]).should == 2
      @user_set.remaining_in_set([16]).should == 3
    end

    it 'should count partial sets as reviewed' do
      @user_set.remaining_in_set([1,16]).should == 2
    end

    it 'should include items in subsequent chapters' do
      Idiom.make!.tap do |idiom|
      Translation.make!(:idiom_id => idiom.id, :language_id => @language.id)
      Translation.make!(:idiom_id => idiom.id, :language_id => @language_being_learned.id)
      SetTerms.make!(:set_id => @set.id, :term_id => idiom.id, :chapter => 2)
      end

      @user_set.remaining_in_set([1]).should == 3
    end
end
end
