# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UserCardReview do
  context 'to be valid' do
    it 'should have a user_id' do
      user_card_review = UserCardReview.new(:card_id => 2, :due => Time.now, :review_start => Time.now, :reveal => Time.now, :result_recorded => Time.now, :result_success => UserCardReview::RESULTS.first, :interval => 5)
      user_card_review.valid?.should == false
      user_card_review.user_id = 1
      user_card_review.valid?.should == true
    end

    it 'should have a card_id' do
      user_card_review = UserCardReview.new(:user_id => 1, :due => Time.now, :review_start => Time.now, :reveal => Time.now, :result_recorded => Time.now, :result_success => UserCardReview::RESULTS.first, :interval => 5)
      user_card_review.valid?.should == false
      user_card_review.card_id = 1
      user_card_review.valid?.should == true
    end

    it 'should have the datetime due' do
      user_card_review = UserCardReview.new(:user_id => 1, :card_id => 2, :review_start => Time.now, :reveal => Time.now, :result_recorded => Time.now, :result_success => UserCardReview::RESULTS.first, :interval => 5)
      user_card_review.valid?.should == false
      user_card_review.due = Time.now
      user_card_review.valid?.should == true
    end

    it 'should have the datetime the review started' do
      user_card_review = UserCardReview.new(:user_id => 1, :card_id => 2, :due => Time.now, :reveal => Time.now, :result_recorded => Time.now, :result_success => UserCardReview::RESULTS.first, :interval => 5)
      user_card_review.valid?.should == false
      user_card_review.review_start = Time.now
      user_card_review.valid?.should == true
    end

    it 'should have the datetime the reveal occurred' do
      user_card_review = UserCardReview.new(:user_id => 1, :card_id => 2, :due => Time.now, :review_start => Time.now, :result_recorded => Time.now, :result_success => UserCardReview::RESULTS.first, :interval => 5)
      user_card_review.valid?.should == false
      user_card_review.reveal = Time.now
      user_card_review.valid?.should == true
    end

    it 'should have the datetime the result was recorded' do
      user_card_review = UserCardReview.new(:user_id => 1, :card_id => 2, :due => Time.now, :review_start => Time.now, :reveal => Time.now, :result_success => UserCardReview::RESULTS.first, :interval => 5)
      user_card_review.valid?.should == false
      user_card_review.result_recorded = Time.now
      user_card_review.valid?.should == true
    end
    
    it 'should have the interval' do
      user_card_review = UserCardReview.new(:user_id => 1, :card_id => 2, :due => Time.now, :review_start => Time.now, :reveal => Time.now, :result_recorded => Time.now, :result_success => UserCardReview::RESULTS.first)
      user_card_review.valid?.should == false
      user_card_review.interval = 5
      user_card_review.valid?.should == true
    end
    
    it 'should have the result_success' do
      user_card_review = UserCardReview.new(:user_id => 1, :card_id => 2, :due => Time.now, :review_start => Time.now, :reveal => Time.now, :result_recorded => Time.now, :interval => 5)
      user_card_review.valid?.should == false
      user_card_review.result_success = UserCardReview::RESULTS.first
      user_card_review.valid?.should == true
    end

    it 'should be invalid if result_success is not in allowed list' do
      user_card_review = UserCardReview.new(:user_id => 1, :card_id => 2, :due => Time.now, :review_start => Time.now, :reveal => Time.now, :result_recorded => Time.now, :interval => 5)

      user_card_review.valid?().should be false

      UserCardReview::RESULTS.each do |result|
        user_card_review.result_success = result
        user_card_review.valid?().should == true
        user_card_review.errors.empty?.should == true
      end

      user_card_review.result_success = 'banana'
      user_card_review.valid?().should == false
    end
  end
end
