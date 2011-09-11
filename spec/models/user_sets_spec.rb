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
    it 'should return records the user has as a goal'
    it 'should not return records for other users'
    it 'should not return records where the user is no longer learning the language'
  end
end
