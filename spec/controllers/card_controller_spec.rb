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
    
    it 'should not redirect to user home if the deck does not belong to the user but is shared' do
      user2 = User.create(:email => 'testing2@testing.com', :password => 'password', :confirm_password => 'password')

      deck = Deck.new(:name => 'my deck', :lang => "en", :country => 'au', :shared => true)
      deck.user = user2
      deck.save!

      card = Card.new(:front => 'front')
      card.deck = deck
      card.save!

      get :show, :deck_id => deck.id, :id => card.id

      response.should_not be_redirect
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
      review_start = Time.now - 20
      get :reveal, :deck_id => @deck.id, :id => @card.id, :review_start => review_start

      assigns[:card].should == @card
      assigns[:reveal].should >= Time.now - 5
      assigns[:reveal].should <= Time.now
      assigns[:card_schedule].should == UserCardSchedule.where(:card_id => @card.id, :user_id => @user.id).first
    end

    it 'should return the passed in review_start date' do
      review_start = Time.now
      get :reveal, :deck_id => @deck.id, :id => @card.id, :review_start => review_start

      assigns[:card].should == @card
      assigns[:review_start].to_s.should == review_start.to_s
    end

    it 'should set review start to now if not supplied' do
      get :reveal, :deck_id => @deck.id, :id => @card.id

      assigns[:card].should == @card
      assigns[:review_start].should >= Time.now - 5
      assigns[:review_start].should <= Time.now
    end

    it 'should quick_response if the difference between review_start and reveal was less than 2 seconds' do
      review_start = Time.now
      get :reveal, :deck_id => @deck.id, :id => @card.id, :review_start => review_start
      assigns[:quick_response].should == true

      review_start = Time.now - 2.00
      get :reveal, :deck_id => @deck.id, :id => @card.id, :review_start => review_start
      assigns[:quick_response].should == true

      review_start = Time.now - 5
      get :reveal, :deck_id => @deck.id, :id => @card.id, :review_start => review_start
      assigns[:quick_response].should == false
    end
  end

  context "'POST' review" do
    it_should_behave_like "all operations"
    it_should_behave_like "all operations that require a card"

    before(:each) do
      @card = Card.new(:front => 'front')
      @card.deck = @deck
      @card.save!

      @scheduled_card = UserCardSchedule.create(:card_id => @card.id, :user_id => @user.id, :due => 1.day.ago, :interval => 0)

      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => 120)
      CardTiming.create(:seconds => 600)
    end

    it 'should redirect to deck session if answer is not in results' do
      post :review, :deck_id => @deck.id, :id => @card.id, :answer => ''
      response.should be_redirect
      response.should redirect_to(learn_deck_path)

      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'adlksfhjjas'
      response.should be_redirect
      response.should redirect_to(learn_deck_path)
    end

    it 'should redirect to deck session path in positive case' do
      UserCardReview::RESULTS.each do |result|
        post :review, :deck_id => @deck.id, :id => @card.id, :answer => result
        response.should be_redirect
        response.should redirect_to(learn_deck_path)
      end
    end

    it 'should reschedule the card for the next interval if it was correct' do
      start_time = Time.now
      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'shaky_good'
      stop_time = Time.now

      @scheduled_card.reload
      @scheduled_card.interval.should == 5
      @scheduled_card.due.should >= start_time + @scheduled_card.interval
      @scheduled_card.due.should <= stop_time + @scheduled_card.interval

      start_time = Time.now
      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'shaky_good'
      stop_time = Time.now

      @scheduled_card.reload
      @scheduled_card.interval.should == 25
      @scheduled_card.due.should >= start_time + @scheduled_card.interval
      @scheduled_card.due.should <= stop_time + @scheduled_card.interval
    end

    it 'should reschedule the card ahead an extra interval if the good response was recieved' do
      start_time = Time.now
      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'good'
      stop_time = Time.now

      @scheduled_card.reload
      @scheduled_card.interval.should == 25
      @scheduled_card.due.should >= start_time + @scheduled_card.interval
      @scheduled_card.due.should <= stop_time + @scheduled_card.interval

      start_time = Time.now
      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'good'
      stop_time = Time.now

      @scheduled_card.reload
      @scheduled_card.interval.should == 600
      @scheduled_card.due.should >= start_time + @scheduled_card.interval
      @scheduled_card.due.should <= stop_time + @scheduled_card.interval
    end

    it 'should reschedule the card for 5 seconds if it was incorrect' do
      start_time = Time.now
      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'didnt_know'
      stop_time = Time.now

      @scheduled_card.reload
      @scheduled_card.interval.should == 5
      @scheduled_card.due.should >= start_time + @scheduled_card.interval
      @scheduled_card.due.should <= stop_time + @scheduled_card.interval

      start_time = Time.now
      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'partial_correct'
      stop_time = Time.now

      @scheduled_card.reload
      @scheduled_card.interval.should == 5
      @scheduled_card.due.should >= start_time + @scheduled_card.interval
      @scheduled_card.due.should <= stop_time + @scheduled_card.interval
    end

    it 'should record a user card review' do
      start_interval = @scheduled_card.interval
      card_due_date = @scheduled_card.due
      review_start = Time.now - 20
      reveal_date = Time.now - 10

      start_time = Time.now
      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'good', :review_start => review_start, :reveal => reveal_date
      stop_time = Time.now

      user_card_review = UserCardReview.first

      user_card_review.card_id.should == @card.id
      user_card_review.user_id.should == @user.id
      user_card_review.due.should == card_due_date
      user_card_review.review_start.should == review_start
      user_card_review.reveal.utc.should == reveal_date.utc
      user_card_review.result_recorded.should >= start_time
      user_card_review.result_recorded.should <= stop_time
      user_card_review.result_success.should == "good"
      user_card_review.interval.should == start_interval



      UserCardReview.delete_all
      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'didnt_know', :review_start => review_start, :reveal => reveal_date
      user_card_review = UserCardReview.first
      user_card_review.result_success.should == "didnt_know"

      UserCardReview.delete_all
      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'partial_correct', :review_start => review_start, :reveal => reveal_date
      user_card_review = UserCardReview.first
      user_card_review.result_success.should == "partial_correct"

      UserCardReview.delete_all
      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'shaky_good', :review_start => review_start, :reveal => reveal_date
      user_card_review = UserCardReview.first
      user_card_review.result_success.should == "shaky_good"
    end

    it 'should set review_start and reveal to now if not supplied' do
      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'didnt_know'

      user_card_review = UserCardReview.first
      user_card_review.review_start.should >= Time.now - 5
      user_card_review.review_start.should <= Time.now
      user_card_review.reveal.should >= Time.now - 5
      user_card_review.reveal.should <= Time.now
    end
  end
end
