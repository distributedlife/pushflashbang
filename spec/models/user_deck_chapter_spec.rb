require 'spec_helper'

describe UserDeckChapter do
  context 'to be valid' do
    it 'should have a user_id' do
      user_card_review = UserDeckChapter.new(:deck_id => 2, :chapter => 1)
      user_card_review.valid?.should == false
      user_card_review.user_id = 1
      user_card_review.valid?.should == true
    end

    it 'should have a deck_id' do
      user_card_review = UserDeckChapter.new(:user_id => 1, :chapter => 1)
      user_card_review.valid?.should == false
      user_card_review.deck_id = 1
      user_card_review.valid?.should == true
    end

    it 'should have a chapter' do
      user_card_review = UserDeckChapter.new(:user_id => 1, :deck_id => 2)
      user_card_review.valid?.should == false
      user_card_review.chapter = 1
      user_card_review.valid?.should == true
    end

    it 'should have a chapter greater than or equal to 1' do
      user_card_review = UserDeckChapter.new(:user_id => 1, :deck_id => 2, :chapter => 0)
      user_card_review.valid?.should == false
      user_card_review.chapter = 1
      user_card_review.valid?.should == true
    end
  end
end
