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
  end
end
