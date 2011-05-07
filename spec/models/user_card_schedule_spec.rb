require 'spec_helper'

describe UserCardSchedule do
  context 'create' do
    it 'should require user_id' do
      card_schedule = UserCardSchedule.new(:card_id => 1, :due => Time.now, :interval => 5)
      card_schedule.valid?.should == false
      card_schedule.user_id = 2
      card_schedule.valid?.should == true
    end

    it 'should require card_id' do
      card_schedule = UserCardSchedule.new(:user_id => 1, :due => Time.now, :interval => 5)
      card_schedule.valid?.should == false
      card_schedule.card_id = 2
      card_schedule.valid?.should == true
    end

    it 'should require due' do
      card_schedule = UserCardSchedule.new(:user_id => 1, :card_id => 1, :interval => 5)
      card_schedule.valid?.should == false
      card_schedule.due = 1.day.from_now
      card_schedule.valid?.should == true
    end

    it 'should require interval' do
      card_schedule = UserCardSchedule.new(:user_id => 1, :card_id => 1, :due => Time.now)
      card_schedule.valid?.should == false
      card_schedule.interval = 10
      card_schedule.valid?.should == true
    end
  end

  context 'get_next_due_for_user' do
    before(:each) do
      @user = User.make
      @deck = Deck.make(:user_id => @user.id)

      @card1 = Card.make(:deck_id => @deck.id);
      @card2 = Card.make(:deck_id => @deck.id);

      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => 120)
    end

    it 'should return nil if there are no scheduled items at all' do
      schedule = UserCardSchedule.get_next_due_for_user(@user.id)
      schedule.nil?.should == true
    end

    it 'should return nil if there is no due items' do
      UserCardSchedule.create(:user_id => @user.id, :card_id => @card1.id, :due => 1.day.from_now, :interval => 5)
      
      schedule = UserCardSchedule.get_next_due_for_user(@user.id)
      schedule.nil?.should == true
    end

    it 'should return the most due item' do
      UserCardSchedule.create(:user_id => @user.id, :card_id => @card1.id, :due => 1.day.ago, :interval => 5)
      UserCardSchedule.create(:user_id => @user.id, :card_id => @card2.id, :due => 2.day.ago, :interval => 5)

      schedule = UserCardSchedule.get_next_due_for_user(@user.id)
      schedule.user_id.should == @user.id
      schedule.card_id.should == @card2.id
    end
  end

  context 'get_due_count_for_user' do
    before(:each) do
      @user = User.make
      @deck = Deck.make(:user_id => @user.id)

      @card1 = Card.make(:deck_id => @deck.id);
      @card2 = Card.make(:deck_id => @deck.id);

      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => 120)
    end

    it 'should not include cards that are not due' do
      UserCardSchedule.create(:user_id => @user.id, :card_id => @card1.id, :due => 1.day.from_now, :interval => 5)
      UserCardSchedule.create(:user_id => @user.id, :card_id => @card2.id, :due => 2.day.from_now, :interval => 5)

      UserCardSchedule.get_due_count_for_user(@user.id).should == 0
    end

    it 'should include cards that are due' do
      UserCardSchedule.create(:user_id => @user.id, :card_id => @card1.id, :due => 1.day.ago, :interval => 5)
      UserCardSchedule.create(:user_id => @user.id, :card_id => @card2.id, :due => 2.day.ago, :interval => 5)

      UserCardSchedule.get_due_count_for_user(@user.id).should == 2
    end
  end

  context 'get_due_count_for_user_for_deck' do
    before(:each) do
      @user = User.make

      @deck1 = Deck.make(:user_id => @user.id)
      @deck2 = Deck.make(:user_id => @user.id)

      @card1 = Card.make(:deck_id => @deck1.id);
      @card2 = Card.make(:deck_id => @deck2.id);

      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => 120)
    end

    it 'should not include cards that are not due' do
      UserCardSchedule.create(:user_id => @user.id, :card_id => @card1.id, :due => 1.day.from_now, :interval => 5)
      UserCardSchedule.create(:user_id => @user.id, :card_id => @card2.id, :due => 2.day.from_now, :interval => 5)

      UserCardSchedule.get_due_count_for_user_for_deck(@user.id, @deck1.id).should == 0
    end

    it 'should include cards that are due' do
      UserCardSchedule.create(:user_id => @user.id, :card_id => @card1.id, :due => 1.day.ago, :interval => 5)
      UserCardSchedule.create(:user_id => @user.id, :card_id => @card2.id, :due => 2.day.ago, :interval => 5)

      UserCardSchedule.get_due_count_for_user_for_deck(@user.id, @deck1.id).should == 1
    end
  end
end
