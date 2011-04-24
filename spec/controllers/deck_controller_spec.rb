require 'spec_helper'

describe DeckController do
  context '"GET" create' do
    it 'should redirect to the login page if user is not logged in' do
      get :create
      response.should be_redirect

      user = User.create(:email => 'testing@testing.com', :password => 'password', :confirm_password => 'password')
      sign_in :user, user
      get :create
      response.should be_success
    end
  end

  context '"POST" create' do
    before(:each) do
      @user = User.create(:email => 'testing@testing.com', :password => 'password', :confirm_password => 'password')
      sign_in :user, @user
    end

    it 'should redirect to the login page if user is not logged in' do
      sign_out @user
      get :create
      response.should be_redirect

      sign_in :user, @user
      get :create
      response.should be_success
    end

    it 'should return a newly created object' do
      post :create, :deck => {:name => "My new deck", :lang => "en", :country => "au", :user => @user}

      assigns[:deck].name.should == "My new deck"
      assigns[:deck].lang.should == "en"
      assigns[:deck].country.should == "au"
      assigns[:deck].user.should == @user
    end

    it 'should redirect to the deck page' do
      post :create, :deck => {:name => "My new deck", :lang => "en", :country => "au", :user => @user}

      response.should be_redirect
    end

    it 'should have flash message indicating successful deck creation' do
      post :create, :deck => {:name => "My new deck", :lang => "en", :country => "au", :user => @user}

      ap assigns['flash']
    end

    it 'should have an undo link to remove the deck' do
      pending

    end

    it 'should require all mandatory fields' do
      post :create, :deck => {}

      ap assigns[:deck].errors
    end

    it 'should not allow duplicate deck names to be created' do
      post :create, :deck => {:name => "My new deck", :lang => "en", :country => "au", :user => @user}

      post :create, :deck => {:name => "My new deck", :lang => "en", :country => "au", :user => @user}
      ap assigns[:deck].errors
    end
  end
end
