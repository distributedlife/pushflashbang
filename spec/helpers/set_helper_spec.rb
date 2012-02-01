require 'spec_helper'

def current_user
  @user
end

describe SetHelper do
  context 'is_user_at_end_of_chapter' do
    before(:each) do
      @user = User.make!
      sign_in :user, @user
      
      @set = Sets.make!
      @language = Language.make!
      @language2 = Language.make!

      @user.native_language_id = @language2.id
      @user.save!

      UserLanguages.make!(:user_id => @user.id, :language_id => @language.id)
      UserSets.make!(:user_id => @user.id, :set_id => @set.id, :chapter => 1, :language_id => @language.id)

      @idiom_in_next_chapter = Idiom.make!
      Translation.make!(:idiom_id => @idiom_in_next_chapter.id, :language_id => @language.id)
      Translation.make!(:idiom_id => @idiom_in_next_chapter.id, :language_id => @language2.id)
      SetTerms.make!(:set_id => @set.id, :term_id => @idiom_in_next_chapter.id, :chapter => 2, :position => 1)
    end

    it 'should return nil if user is at the end of the chapter' do
      is_user_at_end_of_chapter?(@user.id, @set.id, @language.id, "reading").nil?.should == true
    end

    it 'should redirect if language is not found' do
      is_user_at_end_of_chapter?(@user.id, @set.id, 100, "reading").nil?.should == false
    end

    it 'should redirect if set is not found' do
      is_user_at_end_of_chapter?(@user.id, 100, @language.id, "reading").nil?.should == false
    end

    it 'should redirect if review mode is not set' do
      is_user_at_end_of_chapter?(@user.id, @set.id, @language.id, "water").nil?.should == false
    end

    it 'should redirect if user does not have set as a goal' do
      UserSets.delete_all
      is_user_at_end_of_chapter?(@user.id, @set.id, @language.id, "reading").nil?.should == false
    end

    it 'should redirect if set has no terms in the language' do
      Translation.where(:idiom_id => @idiom_in_next_chapter.id, :language_id => @language.id).first.delete

      is_user_at_end_of_chapter?(@user.id, @set.id, @language.id, "reading").nil?.should == false
    end

    it 'should redirect if the set has not terms in the users native language' do
      Translation.where(:idiom_id => @idiom_in_next_chapter.id, :language_id => @language2.id).first.delete

      is_user_at_end_of_chapter?(@user.id, @set.id, @language.id, "reading").nil?.should == false
    end

    it 'should redirect if user has no term left to schedule in set' do
      uis = UserIdiomSchedule.create(:user_id => @user.id, :idiom_id => @idiom_in_next_chapter.id, :language_id => @language.id)
      UserIdiomDueItems.make!(:user_idiom_schedule_id => uis.id, :review_type => UserIdiomReview::READING, :due => 1.day.from_now)

      is_user_at_end_of_chapter?(@user.id, @set.id, @language.id, "reading").nil?.should == false
    end

    it 'should redirect if user if next term is in chapter' do
      @idiom_in_current_chapter = Idiom.make!
      Translation.make!(:idiom_id => @idiom_in_current_chapter.id, :language_id => @language.id)
      Translation.make!(:idiom_id => @idiom_in_current_chapter.id, :language_id => @language2.id)
      SetTerms.make!(:set_id => @set.id, :term_id => @idiom_in_next_chapter.id, :chapter => 1, :position => 1)

      is_user_at_end_of_chapter?(@user.id, @set.id, @language.id, "reading").nil?.should == false
    end
  end
end