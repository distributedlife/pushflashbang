require 'spec_helper'

describe UserCardReview do
  context 'to be valid' do
    it 'should have a user_id' do
      user_card_review = UserCardReview.new(:card_id => 2, :due => Time.now, :review_start => Time.now, :reveal => Time.now, :result_recorded => Time.now, :result_success => true, :interval => 5)
      user_card_review.valid?.should == false
      user_card_review.user_id = 1
      user_card_review.valid?.should == true
    end

    it 'should have a card_id' do
      user_card_review = UserCardReview.new(:user_id => 1, :due => Time.now, :review_start => Time.now, :reveal => Time.now, :result_recorded => Time.now, :result_success => true, :interval => 5)
      user_card_review.valid?.should == false
      user_card_review.card_id = 1
      user_card_review.valid?.should == true
    end

    it 'should have the datetime due' do
      user_card_review = UserCardReview.new(:user_id => 1, :card_id => 2, :review_start => Time.now, :reveal => Time.now, :result_recorded => Time.now, :result_success => true, :interval => 5)
      user_card_review.valid?.should == false
      user_card_review.due = Time.now
      user_card_review.valid?.should == true
    end

    it 'should have the datetime the review started' do
      user_card_review = UserCardReview.new(:user_id => 1, :card_id => 2, :due => Time.now, :reveal => Time.now, :result_recorded => Time.now, :result_success => true, :interval => 5)
      user_card_review.valid?.should == false
      user_card_review.review_start = Time.now
      user_card_review.valid?.should == true
    end

    it 'should have the datetime the reveal occurred' do
      user_card_review = UserCardReview.new(:user_id => 1, :card_id => 2, :due => Time.now, :review_start => Time.now, :result_recorded => Time.now, :result_success => true, :interval => 5)
      user_card_review.valid?.should == false
      user_card_review.reveal = Time.now
      user_card_review.valid?.should == true
    end

    it 'should have the datetime the result was recorded' do
      user_card_review = UserCardReview.new(:user_id => 1, :card_id => 2, :due => Time.now, :review_start => Time.now, :reveal => Time.now, :result_success => true, :interval => 5)
      user_card_review.valid?.should == false
      user_card_review.result_recorded = Time.now
      user_card_review.valid?.should == true
    end
    
    it 'should have the interval' do
      user_card_review = UserCardReview.new(:user_id => 1, :card_id => 2, :due => Time.now, :review_start => Time.now, :reveal => Time.now, :result_recorded => Time.now, :result_success => true)
      user_card_review.valid?.should == false
      user_card_review.interval = 5
      user_card_review.valid?.should == true
    end
  end
end
