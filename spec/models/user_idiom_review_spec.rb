require 'spec_helper'

describe UserIdiomReview do
  context 'to be valid' do
    it 'should have a user_id' do
      user_card_review = UserIdiomReview.new(:idiom_id => 2, :language_id => 1, :review_type => UserIdiomReview::READING, :due => Time.now, :review_start => Time.now, :reveal => Time.now, :result_recorded => Time.now, :result_success => UserIdiomReview::RESULTS.first, :interval => 5)
      user_card_review.valid?.should == false
      user_card_review.user_id = 1
      user_card_review.valid?.should == true
    end

    it 'should have a idiom_id' do
      user_card_review = UserIdiomReview.new(:user_id => 1, :language_id => 1, :review_type => UserIdiomReview::READING, :due => Time.now, :review_start => Time.now, :reveal => Time.now, :result_recorded => Time.now, :result_success => UserIdiomReview::RESULTS.first, :interval => 5)
      user_card_review.valid?.should == false
      user_card_review.idiom_id = 1
      user_card_review.valid?.should == true
    end

    it 'should have a language_id' do
      user_card_review = UserIdiomReview.new(:user_id => 1, :idiom_id => 1, :review_type => UserIdiomReview::READING, :due => Time.now, :review_start => Time.now, :reveal => Time.now, :result_recorded => Time.now, :result_success => UserIdiomReview::RESULTS.first, :interval => 5)
      user_card_review.valid?.should == false
      user_card_review.language_id = 1
      user_card_review.valid?.should == true
    end

    it 'should have a review_type' do
      user_card_review = UserIdiomReview.new(:user_id => 1, :idiom_id => 2, :language_id => 1, :due => Time.now, :review_start => Time.now, :reveal => Time.now, :result_recorded => Time.now, :result_success => UserIdiomReview::RESULTS.first, :interval => 5)
      user_card_review.valid?.should == false
      user_card_review.review_type = UserIdiomReview::READING
      user_card_review.valid?.should == true
    end

    it 'should be invalid if result_success is not in allowed list' do
      user_card_review = UserIdiomReview.new(:user_id => 1, :idiom_id => 2, :language_id => 1, :due => Time.now, :review_start => Time.now, :reveal => Time.now, :result_recorded => Time.now, :interval => 5, :result_success => UserIdiomReview::RESULTS.first)

      user_card_review.valid?().should be false

      UserIdiomReview::REVIEW_TYPES.each do |review_type|
        user_card_review.review_type = review_type
        user_card_review.valid?().should == true
        user_card_review.errors.empty?.should == true
      end

      user_card_review.review_type = 13
      user_card_review.valid?().should == false
    end

    it 'should have the datetime due' do
      user_card_review = UserIdiomReview.new(:user_id => 1, :idiom_id => 2, :language_id => 1, :review_type => UserIdiomReview::READING, :review_start => Time.now, :reveal => Time.now, :result_recorded => Time.now, :result_success => UserIdiomReview::RESULTS.first, :interval => 5)
      user_card_review.valid?.should == false
      user_card_review.due = Time.now
      user_card_review.valid?.should == true
    end

    it 'should have the datetime the review started' do
      user_card_review = UserIdiomReview.new(:user_id => 1, :idiom_id => 2, :language_id => 1, :review_type => UserIdiomReview::READING, :due => Time.now, :reveal => Time.now, :result_recorded => Time.now, :result_success => UserIdiomReview::RESULTS.first, :interval => 5)
      user_card_review.valid?.should == false
      user_card_review.review_start = Time.now
      user_card_review.valid?.should == true
    end

    it 'should have the datetime the reveal occurred' do
      user_card_review = UserIdiomReview.new(:user_id => 1, :idiom_id => 2, :language_id => 1, :review_type => UserIdiomReview::READING, :due => Time.now, :review_start => Time.now, :result_recorded => Time.now, :result_success => UserIdiomReview::RESULTS.first, :interval => 5)
      user_card_review.valid?.should == false
      user_card_review.reveal = Time.now
      user_card_review.valid?.should == true
    end

    it 'should have the datetime the result was recorded' do
      user_card_review = UserIdiomReview.new(:user_id => 1, :idiom_id => 2, :language_id => 1, :review_type => UserIdiomReview::READING, :due => Time.now, :review_start => Time.now, :reveal => Time.now, :result_success => UserIdiomReview::RESULTS.first, :interval => 5)
      user_card_review.valid?.should == false
      user_card_review.result_recorded = Time.now
      user_card_review.valid?.should == true
    end

    it 'should have the interval' do
      user_card_review = UserIdiomReview.new(:user_id => 1, :idiom_id => 2, :language_id => 1, :review_type => UserIdiomReview::READING, :due => Time.now, :review_start => Time.now, :reveal => Time.now, :result_recorded => Time.now, :result_success => UserIdiomReview::RESULTS.first)
      user_card_review.valid?.should == false
      user_card_review.interval = 5
      user_card_review.valid?.should == true
    end

    it 'should have the result_success' do
      user_card_review = UserIdiomReview.new(:user_id => 1, :idiom_id => 2, :language_id => 1, :review_type => UserIdiomReview::READING, :due => Time.now, :review_start => Time.now, :reveal => Time.now, :result_recorded => Time.now, :interval => 5)
      user_card_review.valid?.should == false
      user_card_review.result_success = UserIdiomReview::RESULTS.first
      user_card_review.valid?.should == true
    end

    it 'should be invalid if review_type is not in allowed list' do
      user_card_review = UserIdiomReview.new(:user_id => 1, :idiom_id => 2, :language_id => 1, :review_type => UserIdiomReview::READING, :due => Time.now, :review_start => Time.now, :reveal => Time.now, :result_recorded => Time.now, :interval => 5)

      user_card_review.valid?().should be false

      UserIdiomReview::RESULTS.each do |result|
        user_card_review.result_success = result
        user_card_review.valid?().should == true
        user_card_review.errors.empty?.should == true
      end

      user_card_review.result_success = 'banana'
      user_card_review.valid?().should == false
    end
  end
end
