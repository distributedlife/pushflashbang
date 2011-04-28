require 'spec_helper'

describe CardController do
  before(:each) do
    @user = User.create(:email => 'testing@testing.com', :password => 'password', :confirm_password => 'password')
    sign_in :user, @user
    @deck = Deck.new(:name => "my deck", :lang => 'en', :country => 'us')
    @deck.user = @user
    @deck.save!
  end
  
  shared_examples_for "all operations" do
    it 'should redirect to user home if the deck does not belong to the user' do
      user2 = User.create(:email => 'testing2@testing.com', :password => 'password', :confirm_password => 'password')

      deck = Deck.new(:name => 'my deck', :lang => "en", :country => 'au')
      deck.user = user2
      deck.save!

      card = Card.new(:front => 'front')
      card.deck = deck
      card.save!

      get :show, :deck_id => deck.id, :id => card.id

      response.should be_redirect
      response.should redirect_to(user_index_path)
    end

    it 'should redirect to user home if the deck does not exist' do
      card = Card.new(:front => 'front')
      card.deck = @deck
      card.save!

      get :show, :deck_id => 100, :id => card.id
      response.should be_redirect
      response.should redirect_to(user_index_path)
    end
  end

  shared_examples_for "all operations that require a card" do
    it 'should redirect to the show deck page if the card does not exist' do
      card = Card.new(:front => 'front')
      card.deck = @deck
      card.save!

      get :show, :deck_id => @deck.id, :id => 100
      response.should be_redirect
      response.should redirect_to(show_deck_path(@deck.id))
    end
    
    it 'should redirect to the show deck page if the card does not belong to the deck' do
      deck2 = Deck.new(:name => "my deck", :lang => 'en', :country => 'us')
      deck2.user = @user
      deck2.save!

      card = Card.new(:front => 'front')
      card.deck = deck2
      card.save!

      get :show, :deck_id => @deck.id, :id => card.id
      response.should be_redirect
      response.should redirect_to(show_deck_path(@deck.id))
    end
  end

  context "'GET' new" do
    it_should_behave_like "all operations"

    it 'should return an empty card' do
      get :new, :deck_id => @deck.id

      assigns[:card].front.nil?.should == true
      assigns[:card].back.nil?.should == true
      assigns[:card].deck.should == @deck
    end
  end

  context "'POST' create" do
    it_should_behave_like "all operations"

    it 'should create a new card' do
      post :create, :deck_id => @deck.id, :card => {:front => "front", :back => "back", :deck_id => @deck.id}

      assigns[:card].front.should == "front"
      assigns[:card].back.should == "back"
      assigns[:card].deck.should == @deck

      Card.count.should == 1
    end

    it 'should not create an invalid card' do
      post :create, :deck_id => @deck.id, :card => {:front => "", :back => "back", :deck_id => @deck.id}

      assigns[:card].id.should == nil
      assigns[:card].front.should == ""
      assigns[:card].back.should == "back"
      assigns[:card].deck.should == @deck

      Card.count.should == 0
    end

    it 'should redirect to the new card page' do
      post :create, :deck_id => @deck.id, :card => {:front => "front", :back => "back", :deck_id => @deck.id}

      response.should be_redirect
      response.should redirect_to(new_deck_card_path(@deck.id))
    end
  end

  context "'GET' edit" do
    it_should_behave_like "all operations"
    it_should_behave_like "all operations that require a card"

    before(:each) do
      @card = Card.new(:front => 'front')
      @card.deck = @deck
      @card.save!
    end

    it 'should return the card to be edited' do
      get :edit, :deck_id => @deck.id, :id => @card.id

      assigns[:card].should == @card
    end
  end

  context "'PUT' update" do
    it_should_behave_like "all operations"
    it_should_behave_like "all operations that require a card"

    before(:each) do
      @card = Card.new(:front => 'front')
      @card.deck = @deck
      @card.save!
    end

    it 'should update the card' do
      put :update, :deck_id => @deck.id, :id => @card.id, :card => {:front => "edited front", :back => 'edited back'}

      @card.reload
      @card.front.should == "edited front"
      @card.back.should == "edited back"
    end

    it 'should not allow updating of cards to an invalid state' do
      put :update, :deck_id => @deck.id, :id => @card.id, :card => {:front => "", :back => 'edited back'}

      @card.reload
      @card.front.should == "front"
      @card.back.should == nil

      assigns[:card].front.should == ""
      assigns[:card].back.should == "edited back"
      assigns[:card].deck.should == @deck
    end

    it 'should redirect to show card' do
      put :update, :deck_id => @deck.id, :id => @card.id, :card => {:front => "edited front", :back => 'edited back'}
      
      response.should be_redirect
      response.should redirect_to(deck_card_path(@card.id))
    end
  end

  context "'DELETE' destroy" do
    it_should_behave_like "all operations"
    it_should_behave_like "all operations that require a card"

    before(:each) do
      @card = Card.new(:front => 'front')
      @card.deck = @deck
      @card.save!
    end

    it 'should delete the card' do
      delete :destroy, :deck_id => @deck.id, :id => @card.id

      Card.count.should == 0
    end

    it 'should redirect to the show deck page' do
      delete :destroy, :deck_id => @deck.id, :id => @card.id

      response.should be_redirect
      response.should redirect_to(show_deck_path(@deck.id))
    end
  end

  context "'GET' show" do
    it_should_behave_like "all operations"
    it_should_behave_like "all operations that require a card"
    
    before(:each) do
      @card = Card.new(:front => 'front')
      @card.deck = @deck
      @card.save!
    end

    it 'should return the card for the given id' do
      get :show, :deck_id => @deck.id, :id => @card.id

      assigns[:card].should == @card
    end
  end

  context "'GET' reveal" do
    it_should_behave_like "all operations"
    it_should_behave_like "all operations that require a card"

    before(:each) do
      @card = Card.new(:front => 'front')
      @card.deck = @deck
      @card.save!
    end

    it 'should return the card for the given id' do
      get :show, :deck_id => @deck.id, :id => @card.id

      assigns[:card].should == @card
    end
  end

  context "'POST' review" do
    it_should_behave_like "all operations"
    it_should_behave_like "all operations that require a card"

    before(:each) do
      @card = Card.new(:front => 'front')
      @card.deck = @deck
      @card.save!

      @scheduled_card = UserCardSchedule.create(:card_id => @card.id, :user_id => @user.id, :due => Time.now, :interval => 0)

      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => 120)
    end

    it 'should redirect to deck session if answer is not "yes" or "no"' do
      post :review, :deck_id => @deck.id, :id => @card.id, :answer => ''
      response.should be_redirect
      response.should redirect_to(learn_deck_path)

      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'adlksfhjjas'
      response.should be_redirect
      response.should redirect_to(learn_deck_path)
    end

    it 'should redirect to deck session path in positive case' do
      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'yes'
      response.should be_redirect
      response.should redirect_to(learn_deck_path)

      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'no'
      response.should be_redirect
      response.should redirect_to(learn_deck_path)
    end

    it 'should reschedule the card for 5 seconds if it was incorrect' do
      start_time = Time.now
      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'yes'
      stop_time = Time.now

      @scheduled_card.reload
      @scheduled_card.interval.should == 5
      @scheduled_card.due.should >= start_time + @scheduled_card.interval
      @scheduled_card.due.should <= stop_time + @scheduled_card.interval

      start_time = Time.now
      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'yes'
      stop_time = Time.now

      @scheduled_card.reload
      @scheduled_card.interval.should == 25
      @scheduled_card.due.should >= start_time + @scheduled_card.interval
      @scheduled_card.due.should <= stop_time + @scheduled_card.interval
    end

    it 'should reschedule the card for the next interval if it was correct' do
      start_time = Time.now
      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'yes'
      stop_time = Time.now

      @scheduled_card.reload
      @scheduled_card.interval.should == 5
      @scheduled_card.due.should >= start_time + @scheduled_card.interval
      @scheduled_card.due.should <= stop_time + @scheduled_card.interval
    end
  end
end
