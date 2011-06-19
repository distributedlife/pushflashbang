require 'spec_helper'

describe Card do
  before(:each) do
    @user = User.make
    @deck = Deck.make(:user_id => @user.id)
  end

  context 'to be valid' do
    it 'should be associated with a deck' do
      card = Card.new(:front => 'front', :back => 'back', :chapter => 1)

      card.valid?.should == false
      card.deck = @deck
      card.valid?.should == true
    end

    it 'should require a front' do
      card = Card.new(:back => 'back', :chapter => 1)
      card.deck = @deck

      card.valid?.should == false
      card.front = "front"
      card.valid?.should == true
    end

    it 'should require a chapter' do
      card = Card.new(:front => "fdgdfg", :back => 'back')
      card.deck = @deck

      card.valid?.should == false
      card.chapter = 1
      card.valid?.should == true
    end

    it 'should have a chapter greater than 0' do
      card = Card.new(:front => "fdgdfg", :back => 'back', :chapter => 0)
      card.deck = @deck

      card.valid?.should == false
      card.chapter = 1
      card.valid?.should == true

      card.chapter = 'a'
      card.valid?.should == false
    end
  end

  context 'get_first_unscheduled_card_for_deck_for_user' do
    it 'should return nil if no unscheduled cards exist for user' do
      next_card = Card::get_first_unscheduled_card_for_deck_for_user(@user.id, @deck.id)

      next_card.nil?.should == true
    end

    it 'should return the next upcoming card if there are many to choose' do
      card1 = Card.make(:deck_id => @deck.id)
      card2 = Card.make(:deck_id => @deck.id)
      card3 = Card.make(:deck_id => @deck.id)

      UserCardSchedule.make(:user_id => @user.id, :card_id => card1.id)

      next_card = Card::get_first_unscheduled_card_for_deck_for_user(@user.id, @deck.id)

      next_card.nil?.should == false
      next_card.id.should == card2.id
    end

    it 'should not consider cards in other decks' do
      deck2 = Deck.make(:user_id => @user.id)

      card1 = Card.make(:deck_id => deck2.id)
      card2 = Card.make(:deck_id => @deck.id)
      card3 = Card.make(:deck_id => @deck.id)

      next_card = Card::get_first_unscheduled_card_for_deck_for_user(@user.id, @deck.id)

      next_card.nil?.should == false
      next_card.id.should == card2.id
    end

    it 'should not consider cards for other users' do
      user2 = User.make

      card1 = Card.make(:deck_id => @deck.id)
      card2 = Card.make(:deck_id => @deck.id)
      card3 = Card.make(:deck_id => @deck.id)

      UserCardSchedule.make(:user_id => user2.id, :card_id => card1.id)

      next_card = Card::get_first_unscheduled_card_for_deck_for_user(@user.id, @deck.id)

      next_card.nil?.should == false
      next_card.id.should == card1.id
    end
  end

  context 'delete card' do
    it 'should delete the card' do
      Card.count.should be 0

      card = Card.make(:deck_id => @deck.id)
      Card.count.should be 1


      card.delete
      Card.count.should be 0
    end

    it 'should delete any scheduled cards' do
      UserCardSchedule.count.should be 0

      card = Card.make(:deck_id => @deck.id)
      UserCardSchedule.make(:card_id => card.id, :user_id => @user.id)
      UserCardSchedule.count.should be 1


      card.delete
      UserCardSchedule.count.should be 0
    end

    it 'should not delete any user card reviews' do
      UserCardReview.count.should be 0

      card = Card.make(:deck_id => @deck.id)
      UserCardReview.make(:card_id => card.id, :user_id => @user.id)
      UserCardReview.make(:card_id => card.id, :user_id => @user.id)
      UserCardReview.count.should be 2


      card.delete
      UserCardReview.count.should be 2
    end
  end
end
