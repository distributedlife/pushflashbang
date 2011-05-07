require 'spec_helper'

describe UsersController do
  context 'index' do
    before(:each) do
      @user = User.make
      sign_in :user, @user
    end

    it 'should return success' do
      get :index
      
      response.should be_success
    end

    it 'should return all decks for user in alphabetical order' do
      get :index
      assigns[:decks].empty?.should == true

      deck = Deck.make(:user_id => @user.id, :name => 'my first deck')
      deck = Deck.make(:user_id => @user.id, :name => 'a second deck')

      get :index
      assigns[:decks].count.should == 2
      assigns[:decks][0].name.should == "a second deck"
      assigns[:decks][1].name.should == "my first deck"
    end

    it 'should return decks created by other users that are shared' do
      deck = Deck.make(:user_id => @user.id, :name => 'my first deck')
      deck = Deck.make(:user_id => @user.id + 1, :name => 'a second deck', :shared => true)
      deck = Deck.make(:user_id => @user.id + 1, :name => 'a third deck', :shared => false)

      get :index
      assigns[:decks].count.should == 2
      assigns[:decks][0].name.should == "a second deck"
      assigns[:decks][1].name.should == "my first deck"
    end

    it 'should return the card count for each deck' do
      deck = Deck.make(:user_id => @user.id)
      card = Card.make(:deck_id => deck.id)

      get :index

      assigns[:card_counts][deck.id].should == 1
    end

    it 'should return the due card count for each deck' do
      deck = Deck.make(:user_id => @user.id)
      card = Card.make(:deck_id => deck.id)
      scheduled_card = UserCardSchedule.make(:due, :card_id => card.id, :user_id => @user.id)

      get :index

      assigns[:due_counts][deck.id].should == 1
    end
  end
end
