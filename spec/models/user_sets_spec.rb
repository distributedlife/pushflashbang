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
      @user = User.make
      @set = Sets.make
      @language = Language.make
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
end
