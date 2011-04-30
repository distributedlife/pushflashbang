require 'spec_helper'

describe UsersController do
  context 'index' do
    before(:each) do
      @user = User.create(:email => 'testing@testing.com', :password => 'password', :confirm_password => 'password')
      sign_in :user, @user
    end

    it 'should return success' do
      get :index
      
      response.should be_success
    end

    it 'should return all decks for user in alphabetical order' do
      get :index
      assigns[:decks].empty?.should == true

      deck = Deck.new(:name => 'my first deck', :lang => "en", :country => 'au')
      deck.user = @user
      deck.save!
      deck = Deck.new(:name => 'a second deck', :lang => "en", :country => 'au')
      deck.user = @user
      deck.save!

      get :index
      assigns[:decks].count.should == 2
      assigns[:decks][0].name.should == "a second deck"
      assigns[:decks][1].name.should == "my first deck"
    end

    it 'should return decks created by other users that are shared' do
      deck = Deck.new(:name => 'my first deck', :lang => "en", :country => 'au')
      deck.user = @user
      deck.save!
      deck = Deck.new(:name => 'a second deck', :lang => "en", :country => 'au', :shared => true)
      deck.user_id = @user.id + 1
      deck.save!
      deck = Deck.new(:name => 'a third deck', :lang => "en", :country => 'au', :shared => false)
      deck.user_id = @user.id + 1
      deck.save!

      get :index
      assigns[:decks].count.should == 2
      assigns[:decks][0].name.should == "a second deck"
      assigns[:decks][1].name.should == "my first deck"
    end

    it 'should return the card count for each deck' do
      deck = Deck.new(:name => 'my first deck', :lang => "en", :country => 'au')
      deck.user = @user
      deck.save!

      card = Card.new(:front => "front", :back => "back")
      card.deck = deck
      card.save!

      get :index

      assigns[:card_counts][deck.id].should == 1
    end

    it 'should return the due card count for each deck' do
      deck = Deck.new(:name => 'my first deck', :lang => "en", :country => 'au')
      deck.user = @user
      deck.save!

      card = Card.new(:front => "front", :back => "back")
      card.deck = deck
      card.save!

      scheduled_card = UserCardSchedule.create(:card_id => card.id, :user_id => @user.id, :due => 1.day.ago, :interval => 0)

      get :index

      assigns[:due_counts][deck.id].should == 1
    end
  end
end
