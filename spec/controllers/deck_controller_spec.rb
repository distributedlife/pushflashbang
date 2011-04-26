require 'spec_helper'

describe DeckController do
  context '"GET" create' do
    it 'should redirect to the login page if user is not logged in' do
      get :create
      response.should be_redirect
      response.should redirect_to(new_user_session_path)

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
      response.should redirect_to(new_user_session_path)

      sign_in :user, @user
      get :create
      response.should be_success
    end

    it 'should return a newly created object' do
      post :create, :deck => {:name => "My new deck", :lang => "en", :country => "au"}

      assigns[:deck].name.should == "My new deck"
      assigns[:deck].lang.should == "en"
      assigns[:deck].country.should == "au"
      assigns[:deck].user.should == @user
    end

    it 'should redirect to the deck page' do
      post :create, :deck => {:name => "My new deck", :lang => "en", :country => "au"}

      response.should be_redirect
      response.should redirect_to(show_deck_path(Deck.last.id))
    end

    it 'should have flash message indicating successful deck creation' do
      post :create, :deck => {:name => "My new deck", :lang => "en", :country => "au"}

      flash[:info].should ~ /^Deck successfully created!/
    end

    it 'should have an undo text to remove the deck' do
      post :create, :deck => {:name => "My new deck", :lang => "en", :country => "au"}
      
      flash[:info].should ~ /Click here to undo./
    end

    it 'should require all mandatory fields' do
      post :create, :deck => {}

      assigns[:deck].errors[:name].should == ["can't be blank"]
      assigns[:deck].errors[:lang].should == ["can't be blank"]
      assigns[:deck].errors[:country].should == ["can't be blank"]
    end
  end

  context '"GET" edit' do
    before(:each) do
      @user = User.create(:email => 'testing@testing.com', :password => 'password', :confirm_password => 'password')
      sign_in :user, @user
    end

    it 'should return the deck for the given id' do
      deck = Deck.new(:name => 'my deck', :lang => "en", :country => 'au')
      deck.user = @user
      deck.save!

      get :edit, :id => deck.id

      assigns[:deck].should == deck
    end

    it 'should redirect to user home if the id does not belong to the user' do
      user2 = User.create(:email => 'testing2@testing.com', :password => 'password', :confirm_password => 'password')

      deck = Deck.new(:name => 'my deck', :lang => "en", :country => 'au')
      deck.user = user2
      deck.save!

      get :edit, :id => deck.id

      response.should be_redirect
      response.should redirect_to(user_index_path)
    end

    it 'should redirect to user home if the id does not exist' do
      get :edit, :id => 1

      response.should be_redirect
      response.should redirect_to(user_index_path)
    end
  end

  context '"PUT" update' do
    before(:each) do
      @user = User.create(:email => 'testing@testing.com', :password => 'password', :confirm_password => 'password')
      sign_in :user, @user
    end

    it 'should update the deck for the given id' do
      deck = Deck.new(:name => 'my deck', :lang => "en", :country => 'au')
      deck.user = @user
      deck.save!

      put :update, :id => deck.id, :deck => {:id => deck.id, :name => "edited name", :description => 'edited description', :lang => 'cn', :country => 'es'}

      deck.reload
      deck.name.should == "edited name"
      deck.description.should == "edited description"
      deck.lang.should == "cn"
      deck.country.should == "es"

      response.should redirect_to(show_deck_path(deck.id))
    end

    it 'should redirect to user home if the id does not belong to the user' do
      user2 = User.create(:email => 'testing2@testing.com', :password => 'password', :confirm_password => 'password')

      deck = Deck.new(:name => 'my deck', :lang => "en", :country => 'au')
      deck.user = user2
      deck.save!

      put :update, :id => deck.id, :deck => {:name => "edited name", :description => 'edited description', :lang => 'cn', :country => 'es'}

      response.should be_redirect
      response.should redirect_to(user_index_path)
      deck.reload
      deck.name.should == "my deck"
      deck.description.should == nil
      deck.lang.should == "en"
      deck.country.should == "au"
    end

    it 'should redirect to user home if the id does not exist' do
      put :update, :id => 1, :deck => {:name => "edited name", :description => 'edited description', :lang => 'cn', :country => 'es'}

      response.should be_redirect
      response.should redirect_to(user_index_path)
    end

    it 'should not update the user attribute' do
      user2 = User.create(:email => 'testing2@testing.com', :password => 'password', :confirm_password => 'password')

      deck = Deck.new(:name => 'my deck', :lang => "en", :country => 'au')
      deck.user = @user
      deck.save!

      put :update, :id => deck.id, :deck => {:user => user2, :name => "edited name", :description => 'edited description', :lang => 'cn', :country => 'es'}

      response.should be_redirect
      deck.reload
      deck.name.should == "edited name"
      deck.description.should == "edited description"
      deck.lang.should == "cn"
      deck.country.should == "es"
      deck.user.should == @user
    end

    it 'should not update if the deck is made invalid' do
      deck = Deck.new(:name => 'my deck', :lang => "en", :country => 'au')
      deck.user = @user
      deck.save!

      put :update, :id => deck.id, :deck => {:id => deck.id, :name => "", :description => 'edited description', :lang => 'cn', :country => 'es'}

      deck.reload
      deck.name.should == "my deck"
      deck.description.should == nil
      deck.lang.should == "en"
      deck.country.should == "au"

      assigns[:deck].name.should == ""
      assigns[:deck].description.should == "edited description"
      assigns[:deck].lang.should == "cn"
      assigns[:deck].country.should == "es"
      assigns[:deck].user.should == @user
    end
  end

  context '"GET" show' do
    before(:each) do
      @user = User.create(:email => 'testing@testing.com', :password => 'password', :confirm_password => 'password')
      sign_in :user, @user
    end
    
    it 'should return the deck for the given id' do
      deck = Deck.new(:name => 'my deck', :lang => "en", :country => 'au')
      deck.user = @user
      deck.save!

      get :show, :id => deck.id

      assigns[:deck].should == deck
    end

    it 'should redirect to user home if the id does not belong to the user' do
      user2 = User.create(:email => 'testing2@testing.com', :password => 'password', :confirm_password => 'password')

      deck = Deck.new(:name => 'my deck', :lang => "en", :country => 'au')
      deck.user = user2
      deck.save!

      get :show, :id => deck.id

      response.should be_redirect
      response.should redirect_to(user_index_path)
    end

    it 'should redirect to user home if the id does not exist' do
      get :show, :id => 1

      response.should be_redirect
      response.should redirect_to(user_index_path)
    end
  end

  context '"DELETE" destroy' do
    before(:each) do
      @user = User.create(:email => 'testing@testing.com', :password => 'password', :confirm_password => 'password')
      sign_in :user, @user
    end

    it 'should delete the deck for the given id' do
      deck = Deck.new(:name => 'my deck', :lang => "en", :country => 'au')
      deck.user = @user
      deck.save!

      delete :destroy, :id => deck.id

      Deck.count.should == 0
      response.should be_redirect
      response.should redirect_to(user_index_path)
    end

    it 'should not delete the deck if the id does not belong to the user' do
      user2 = User.create(:email => 'testing2@testing.com', :password => 'password', :confirm_password => 'password')

      deck = Deck.new(:name => 'my deck', :lang => "en", :country => 'au')
      deck.user = user2
      deck.save!

      delete :destroy, :id => deck.id

      response.should be_redirect
      response.should redirect_to(user_index_path)
      Deck.count.should == 1
    end

    it 'should be a success if the id does not exist' do
      delete :destroy, :id => 1

      response.should be_redirect
      response.should redirect_to(user_index_path)
    end
  end
end
