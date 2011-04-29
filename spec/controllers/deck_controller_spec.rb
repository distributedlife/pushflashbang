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

    it 'should return the cards for the given deck' do
      deck = Deck.new(:name => 'my deck', :lang => "en", :country => 'au')
      deck.user = @user
      deck.save!

      get :show, :id => deck.id

      assigns[:deck].should == deck
      assigns[:cards].should == Card.where(:deck_id => deck.id)
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

  context "'GET' learn" do
    before(:each) do
      @user = User.create(:email => 'testing@testing.com', :password => 'password', :confirm_password => 'password')
      sign_in :user, @user

      @deck = Deck.new(:name => 'my deck', :lang => "en", :country => 'au')
      @deck.user = @user
      @deck.save!

      @card1 = Card.new(:front => 'first card', :back => 'back of first')
      @card1.deck = @deck
      @card1.save!

      @card2 = Card.new(:front => 'second card', :back => 'back of second')
      @card2.deck = @deck
      @card2.save!

      @card3 = Card.new(:front => 'third card', :back => 'back of third')
      @card3.deck = @deck
      @card3.save!

      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => 120)
    end

    it 'should redirect to show deck page if there are no cards in the deck' do
      Card.delete_all

      get :learn, :id => @deck.id

      response.should be_redirect
      response.should redirect_to(deck_path(@deck.id))
    end

    context "user has never started a session" do
      before(:each) do
        UserCardSchedule.delete_all
      end

      it 'should schedule the first card in the deck' do
        start_of_test = Time.now

        get :learn, :id => @deck.id

        assigns[:scheduled_card].user_id.should == @user.id
        assigns[:scheduled_card].card_id.should == @card1.id
        assigns[:scheduled_card].due.should >= start_of_test
        assigns[:scheduled_card].due.should <= Time.now
        assigns[:scheduled_card].interval.should == 5
        assigns[:card].should == @card1
        assigns[:review_start].should >= Time.now - 5
        assigns[:review_start].should <= Time.now

        UserCardSchedule.count.should == 1
      end
    end

    context "user has cards due" do
      it 'should return the first card due' do
        UserCardSchedule.create(:user_id => @user.id, :card_id => @card1.id, :due => 1.day.ago, :interval => 5)
        UserCardSchedule.create(:user_id => @user.id, :card_id => @card2.id, :due => 2.days.ago, :interval => 5)
        UserCardSchedule.create(:user_id => @user.id, :card_id => @card3.id, :due => 3.days.ago, :interval => 5)

        get :learn, :id => @deck.id

        assigns[:scheduled_card].card_id.should == @card3.id
        assigns[:card].should == @card3
        assigns[:review_start].should >= Time.now - 5
        assigns[:review_start].should <= Time.now

        UserCardSchedule.count.should == 3
      end

      it 'should return the due count' do
        UserCardSchedule.create(:user_id => @user.id, :card_id => @card1.id, :due => 1.day.ago, :interval => 5)
        UserCardSchedule.create(:user_id => @user.id, :card_id => @card2.id, :due => 2.days.ago, :interval => 5)
        UserCardSchedule.create(:user_id => @user.id, :card_id => @card3.id, :due => 3.days.ago, :interval => 5)

        get :learn, :id => @deck.id

        assigns[:due_count].should == 3
      end
    end

    context "user has no cards due" do
      it 'should schedule the next card in the deck' do
        UserCardSchedule.create(:user_id => @user.id, :card_id => @card3.id, :due => 1.day.from_now, :interval => 5)
        UserCardSchedule.create(:user_id => @user.id, :card_id => @card1.id, :due => 2.days.from_now, :interval => 5)

        get :learn, :id => @deck.id

        assigns[:scheduled_card].card_id.should == @card2.id
        assigns[:card].should == @card2
        assigns[:review_start].should >= Time.now - 5
        assigns[:review_start].should <= Time.now

        UserCardSchedule.count.should == 3
      end

      it 'should return upcoming cards if there are no cards to schedule' do
        UserCardSchedule.create(:user_id => @user.id, :card_id => @card3.id, :due => 1.day.from_now, :interval => 5)
        UserCardSchedule.create(:user_id => @user.id, :card_id => @card2.id, :due => 1.day.from_now, :interval => 5)
        UserCardSchedule.create(:user_id => @user.id, :card_id => @card1.id, :due => 2.days.from_now, :interval => 5)

        get :learn, :id => @deck.id

        assigns[:scheduled_card].should == nil
        assigns[:card].should == nil
        assigns[:upcoming_cards].count.should == UserCardSchedule.where(:user_id => @user.id).count

        assigns[:upcoming_cards].first["front"].nil?.should == false
        assigns[:upcoming_cards].first["back"].nil?.should == false
        assigns[:upcoming_cards].first["due"].nil?.should == false
        assigns[:upcoming_cards].first["id"].nil?.should == false

        assigns[:review_start].should >= Time.now - 5
        assigns[:review_start].should <= Time.now

        UserCardSchedule.count.should == 3
      end
    end
  end
end