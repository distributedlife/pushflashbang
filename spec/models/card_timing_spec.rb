# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CardTiming do
  context 'create' do
    it 'should require seconds' do
      card_timing = CardTiming.new
      card_timing.valid?.should == false
      card_timing.seconds = 5
      card_timing.valid?.should == true
    end
  end

  context 'get_first' do
    it 'should return the row with the smallest value for seconds' do
      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => 1)

      CardTiming::get_first.seconds.should == 1
    end
  end

  context 'get_next' do
    it 'should return the next row with the smallest value after the supplied value' do
      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => 120)

      CardTiming::get_next(5).seconds.should == 25
      CardTiming::get_next(25).seconds.should == 120
    end

    it 'should get the first row if current is zero' do
      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => 120)

      CardTiming::get_next(0).seconds.should == 5
    end

    it 'should get the last row if there is no later' do
      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)

      CardTiming::get_next(25).seconds.should == 25
    end

    it 'should return a range if the current is equal to or above the threshold' do
      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => 120)
      CardTiming.create(:seconds => 600)

      CardTiming::get_next(120).seconds.should >= (600)
      CardTiming::get_next(120).seconds.should <= (660)
    end
  end

  context 'get_next_advance' do
    before(:each) do
      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => CardTiming::SECONDS_IN_MINUTE * 2)        # 2 minutes
      CardTiming.create(:seconds => CardTiming::SECONDS_IN_MINUTE * 10)       # 10 minutes
      CardTiming.create(:seconds => CardTiming::SECONDS_IN_HOUR)              # 1 hour
      CardTiming.create(:seconds => CardTiming::SECONDS_IN_HOUR * 5)          # 5 hours
      CardTiming.create(:seconds => CardTiming::SECONDS_IN_DAY)               # 1 day
      CardTiming.create(:seconds => CardTiming::SECONDS_IN_DAY * 5)           # 5 days
      CardTiming.create(:seconds => CardTiming::SECONDS_IN_DAY * 25)          # 25 days
      CardTiming.create(:seconds => CardTiming::SECONDS_IN_MONTH * 4)         # 4 months
      CardTiming.create(:seconds => CardTiming::SECONDS_IN_YEAR * 2)          # 2 years
    end

    it 'should return the next row with the smallest value after the supplied value' do
      CardTiming::get_next_advance(0).seconds.should == CardTiming::SECONDS_IN_HOUR
      CardTiming::get_next_advance(5).seconds.should == CardTiming::SECONDS_IN_HOUR
      CardTiming::get_next_advance(25).seconds.should == CardTiming::SECONDS_IN_HOUR
      CardTiming::get_next_advance(CardTiming::SECONDS_IN_HOUR).seconds.should >= CardTiming::SECONDS_IN_HOUR * 5
      CardTiming::get_next_advance(CardTiming::SECONDS_IN_HOUR).seconds.should <= CardTiming::SECONDS_IN_HOUR * 5 * CardTiming::get_max_variance
      CardTiming::get_next_advance(CardTiming::SECONDS_IN_DAY).seconds.should >= (CardTiming::SECONDS_IN_DAY * 5)
      CardTiming::get_next_advance(CardTiming::SECONDS_IN_DAY).seconds.should <= (CardTiming::SECONDS_IN_DAY * 5) * CardTiming::get_max_variance

    end

    it 'should get the last row if there is no later' do
      CardTiming::get_next_advance(CardTiming::SECONDS_IN_YEAR * 2).seconds.should >= (CardTiming::SECONDS_IN_YEAR * 2)
      CardTiming::get_next_advance(CardTiming::SECONDS_IN_YEAR * 2).seconds.should <= (CardTiming::SECONDS_IN_YEAR * 2) * CardTiming::get_max_variance
    end

    it 'should not return a range if the current is equal to or above the threshold' do
      CardTiming::get_next_advance(120).seconds.should >= CardTiming::SECONDS_IN_HOUR
      CardTiming::get_next_advance(120).seconds.should <= CardTiming::SECONDS_IN_HOUR * CardTiming::get_max_variance
    end
  end
end
