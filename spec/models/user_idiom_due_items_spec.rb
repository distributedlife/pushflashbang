require 'spec_helper'

describe UserIdiomDueItems do
  context 'create' do
    it 'should require a user_id' do
      card_schedule = UserIdiomDueItems.new(:review_type => 1, :interval => 5, :due => Time.now)
      card_schedule.valid?.should == false
      card_schedule.user_idiom_schedule_id = 2
      card_schedule.valid?.should == true
    end

    it 'should require an review_type' do
      card_schedule = UserIdiomDueItems.new(:user_idiom_schedule_id => 1, :interval => 5, :due => Time.now)
      card_schedule.valid?.should == false
      card_schedule.review_type = 2
      card_schedule.valid?.should == true
    end

    it 'should require a interval' do
      card_schedule = UserIdiomDueItems.new(:user_idiom_schedule_id => 1, :review_type => 1, :due => Time.now)
      card_schedule.valid?.should == false
      card_schedule.interval = 10
      card_schedule.valid?.should == true
    end

    it 'should require a due' do
      card_schedule = UserIdiomDueItems.new(:user_idiom_schedule_id => 1, :review_type => 1, :interval => 5)
      card_schedule.valid?.should == false
      card_schedule.due = 1.day.from_now
      card_schedule.valid?.should == true
    end
  end
end
