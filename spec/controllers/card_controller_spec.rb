# -*- encoding : utf-8 -*-
require 'spec_helper'

describe CardController do
  before(:each) do
    @user = User.make!
    sign_in :user, @user

    @deck = Deck.make!(:user_id => @user.id)
  end
  
  shared_examples_for "all shared card operations" do
    it 'should redirect to user home if the deck does not belong to the user' do
      user2 = User.make!
      deck = Deck.make!(:user_id => user2.id)
      card = Card.make!(:deck_id => deck.id)

      get :show, :deck_id => deck.id, :id => card.id

      response.should be_redirect
      response.should redirect_to(user_index_path)
    end
    
    it 'should not redirect to user home if the deck does not belong to the user but is shared' do
      user2 = User.make!
      deck = Deck.make!(:user_id => user2.id, :shared => true)
      card = Card.make!(:deck_id => deck.id)

      get :show, :deck_id => deck.id, :id => card.id

      response.should_not be_redirect
    end

    it 'should redirect to user home if the deck does not exist' do
      card = Card.make!(:deck_id => @deck.id)

      get :show, :deck_id => 100, :id => card.id
      response.should be_redirect
      response.should redirect_to(user_index_path)
    end
  end

  shared_examples_for "all card operations that require an owner" do
    it 'should redirect to user home if the deck does not belong to the user' do
      user2 = User.make!
      deck = Deck.make!(:user_id => user2.id)
      card = Card.make!(:deck_id => deck.id)

      get :show, :deck_id => deck.id, :id => card.id

      response.should be_redirect
      response.should redirect_to(user_index_path)
    end

    it 'should redirect to user home if the deck does not exist' do
      card = Card.make!(:deck_id => @deck.id)

      get :show, :deck_id => 100, :id => card.id
      response.should be_redirect
      response.should redirect_to(user_index_path)
    end
  end

  shared_examples_for "all card operations that require a card" do
    it 'should redirect to the show deck page if the card does not exist' do
      card = Card.make!(:deck_id => @deck.id)

      get :show, :deck_id => @deck.id, :id => 100
      response.should be_redirect
      response.should redirect_to(show_deck_path(@deck.id))
    end
    
    it 'should redirect to the show deck page if the card does not belong to the deck' do
      deck2 = Deck.make!(:user_id => @user.id)
      card = Card.make!(:deck_id => deck2.id)

      get :show, :deck_id => @deck.id, :id => card.id
      response.should be_redirect
      response.should redirect_to(show_deck_path(@deck.id))
    end
  end

  context "'GET' new" do
    it_should_behave_like "all shared card operations"

    it 'should return an empty card' do
      get :new, :deck_id => @deck.id

      assigns[:card].front.nil?.should == true
      assigns[:card].back.nil?.should == true
      assigns[:card].deck.should == @deck
    end
  end

  context "'POST' create" do
    it_should_behave_like "all shared card operations"

    it 'should create a new card' do
      post :create, :deck_id => @deck.id, :card => {:front => "front", :back => "back", :deck_id => @deck.id, :chapter => 1}

      assigns[:card].front.should == "front"
      assigns[:card].back.should == "back"
      assigns[:card].deck.should == @deck

      Card.count.should == 1
    end

    it 'should not create an invalid card' do
      post :create, :deck_id => @deck.id, :card => {:front => "", :back => "back", :deck_id => @deck.id, :chapter => 1}

      assigns[:card].id.should == nil
      assigns[:card].front.should == ""
      assigns[:card].back.should == "back"
      assigns[:card].deck.should == @deck
      assigns[:card].chapter.should == 1

      Card.count.should == 0
    end

    it 'should redirect to the new card page' do
      post :create, :deck_id => @deck.id, :card => {:front => "front", :back => "back", :deck_id => @deck.id, :chapter => 1}

      response.should be_redirect
      response.should redirect_to(new_deck_card_path(@deck.id))
    end
  end

  context "'GET' edit" do
    it_should_behave_like "all shared card operations"
    it_should_behave_like "all card operations that require a card"

    before(:each) do
      @card = Card.make!(:deck_id => @deck.id)
    end

    it 'should return the card to be edited' do
      get :edit, :deck_id => @deck.id, :id => @card.id

      assigns[:card].should == @card
    end
  end

  context "'PUT' update" do
    it_should_behave_like "all shared card operations"
    it_should_behave_like "all card operations that require a card"

    before(:each) do
      @card = Card.make!(:deck_id => @deck.id, :front => 'front', :back => nil)
    end

    it 'should update the card' do
      put :update, :deck_id => @deck.id, :id => @card.id, :card => {:front => "edited front", :back => 'edited back', :chapter => 2}

      @card.reload
      @card.front.should == "edited front"
      @card.back.should == "edited back"
      @card.chapter.should == 2
    end

    it 'should not allow updating of cards to an invalid state' do
      put :update, :deck_id => @deck.id, :id => @card.id, :card => {:front => "", :back => 'edited back', :chapter => 0}

      @card.reload
      @card.front.should == "front"
      @card.back.should == nil

      assigns[:card].front.should == ""
      assigns[:card].back.should == "edited back"
      assigns[:card].deck.should == @deck
      assigns[:card].chapter.should == 0
    end

    it 'should redirect to show card' do
      put :update, :deck_id => @deck.id, :id => @card.id, :card => {:front => "edited front", :back => 'edited back'}
      
      response.should be_redirect
      response.should redirect_to(deck_card_path(@deck.id, @card.id))
    end
  end

  context "'DELETE' destroy" do
    it_should_behave_like "all card operations that require an owner" 
    it_should_behave_like "all card operations that require a card"

    before(:each) do
      @card = Card.make!(:deck_id => @deck.id)
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

    it 'should delete the card schedule and not delete the revierws' do
      UserCardSchedule.make!(:card_id => @card.id, :user_id => @user.id)
      UserCardReview.make!(:card_id => @card.id, :user_id => @user.id)

      delete :destroy, :deck_id => @deck.id, :id => @card.id

      Card.count.should == 0
      UserCardSchedule.count.should == 0
      UserCardReview.count.should == 1
    end
  end

  context "'GET' show" do
    it_should_behave_like "all shared card operations"
    it_should_behave_like "all card operations that require a card"
    
    before(:each) do
      @card = Card.make!(:deck_id => @deck.id)
    end

    it 'should return the card for the given id' do
      get :show, :deck_id => @deck.id, :id => @card.id

      assigns[:card].should == @card
    end
  end

  context "'POST' review" do
    it_should_behave_like "all shared card operations"
    it_should_behave_like "all card operations that require a card"

    before(:each) do
      @card = Card.make!(:deck_id => @deck.id)
      @scheduled_card = UserCardSchedule.make!(:due, :card_id => @card.id, :user_id => @user.id)

      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => 120)
      CardTiming.create(:seconds => 600)
      CardTiming.create(:seconds => 60 * 60)          #1 hour
      CardTiming.create(:seconds => 60 * 60 * 5)      #5 hours
      CardTiming.create(:seconds => 60 * 60 * 24)     #1 day
      CardTiming.create(:seconds => 60 * 60 * 24 * 5) #5 day
    end

    it 'should redirect to deck session if answer is not in results' do
      post :review, :deck_id => @deck.id, :id => @card.id, :answer => ''
      response.should be_redirect
      response.should redirect_to(learn_deck_path(@deck.id))

      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'adlksfhjjas'
      response.should be_redirect
      response.should redirect_to(learn_deck_path(@deck.id))
    end

    it 'should redirect to deck session path in positive case' do
      UserCardReview::RESULTS.each do |result|
        post :review, :deck_id => @deck.id, :id => @card.id, :answer => result
        response.should be_redirect
        response.should redirect_to(learn_deck_path(@deck.id))
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
      @scheduled_card.interval.should == 3600
      @scheduled_card.due.should >= start_time + @scheduled_card.interval
      @scheduled_card.due.should <= stop_time + @scheduled_card.interval


      start_time = Time.now
      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'good'
      stop_time = Time.now

      @scheduled_card.reload
      #considering ranges for larger increments
      @scheduled_card.interval.should >= (60 * 60 * 24) - CardTiming.range
      @scheduled_card.interval.should <= (60 * 60 * 24) + CardTiming.range
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
      duration_in_ms = 9669
      elapsed_in_ms = 12301

      start_time = Time.now
      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'good', :duration => duration_in_ms, :elapsed => elapsed_in_ms
      stop_time = Time.now

      user_card_review = UserCardReview.first

      user_card_review.card_id.should == @card.id
      user_card_review.user_id.should == @user.id
      user_card_review.due.should == card_due_date
      user_card_review.review_start.should >= card_due_date
      user_card_review.review_start.should <= Time.now - (elapsed_in_ms / 1000)
      user_card_review.reveal.utc.to_s.should == (user_card_review.review_start + (duration_in_ms / 1000)).utc.to_s
      user_card_review.result_recorded.should >= start_time
      user_card_review.result_recorded.should <= stop_time
      user_card_review.result_success.should == "good"
      user_card_review.interval.should == start_interval



      UserCardReview.delete_all
      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'didnt_know'
      user_card_review = UserCardReview.first
      user_card_review.result_success.should == "didnt_know"

      UserCardReview.delete_all
      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'partial_correct'
      user_card_review = UserCardReview.first
      user_card_review.result_success.should == "partial_correct"

      UserCardReview.delete_all
      post :review, :deck_id => @deck.id, :id => @card.id, :answer => 'shaky_good'
      user_card_review = UserCardReview.first
      user_card_review.result_success.should == "shaky_good"
    end

    it 'should create multiple reviews if the deck supports multiple review types' do
      deck2 = Deck.make!(:user_id => @user.id, :review_types => Deck::READING | Deck::SPEAKING | Deck::TYPING)

      card2 = Card.make!(:deck_id => deck2.id)
      scheduled_card2 = UserCardSchedule.make!(:due, :card_id => card2.id, :user_id => @user.id)

      start_interval = scheduled_card2.interval
      card_due_date = scheduled_card2.due
      duration_in_ms = 9669
      elapsed_in_ms = 12301

      start_time = Time.now
      post :review, :deck_id => deck2.id, :id => card2.id, :answer => 'good', :duration => duration_in_ms, :elapsed => elapsed_in_ms
      stop_time = Time.now

      review_types_to_find = Deck::READING | Deck::SPEAKING | Deck::TYPING

      UserCardReview.all.each do |user_card_review|
        user_card_review.card_id.should == card2.id
        user_card_review.user_id.should == @user.id
        user_card_review.due.to_s.should == card_due_date.to_s
        user_card_review.review_start.should >= card_due_date
        user_card_review.review_start.should <= Time.now - (elapsed_in_ms / 1000)
        user_card_review.reveal.utc.to_s.should == (user_card_review.review_start + (duration_in_ms / 1000)).utc.to_s
        user_card_review.result_recorded.should >= start_time
        user_card_review.result_recorded.should <= stop_time
        user_card_review.result_success.should == "good"
        user_card_review.interval.should == start_interval

        review_types_to_find = review_types_to_find - user_card_review.review_type
      end

      review_types_to_find.should == 0
    end
  end

  context '"GET" learn' do
    it_should_behave_like "all shared card operations"
    it_should_behave_like "all card operations that require a card"

    before(:each) do
      @deck = Deck.make!(:user_id => @user.id)

      @card1 = Card.make!(:deck_id => @deck.id, :chapter => 1)
      @card2 = Card.make!(:deck_id => @deck.id, :chapter => 1)
      @card3 = Card.make!(:deck_id => @deck.id, :chapter => 1)

      UserCardSchedule.make!(:user_id => @user.id, :card_id => @card1.id, :due => 1.day.ago)

      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => 120)
    end

    it 'should return the card' do
      get :learn, :deck_id => @deck.id, :id => @card1.id

      assigns[:card].should == @card1
      UserCardSchedule.where(:user_id => @user.id, :card_id => @card1.id).count.should == 1
    end

    it 'should schedule the card if it is not already scheduled' do
      get :learn, :deck_id => @deck.id, :id => @card2.id

      assigns[:card].should == @card2
      UserCardSchedule.where(:user_id => @user.id, :card_id => @card1.id).count.should == 1
    end
  end

  context '"GET" cram' do
    it_should_behave_like "all shared card operations"
    it_should_behave_like "all card operations that require a card"

    before(:each) do
      @deck = Deck.make!(:user_id => @user.id)

      @card1 = Card.make!(:deck_id => @deck.id, :chapter => 1)
      @card2 = Card.make!(:deck_id => @deck.id, :chapter => 1)
      @card3 = Card.make!(:deck_id => @deck.id, :chapter => 1)

      UserCardSchedule.make!(:user_id => @user.id, :card_id => @card1.id, :due => 1.day.ago)

      CardTiming.create(:seconds => 5)
      CardTiming.create(:seconds => 25)
      CardTiming.create(:seconds => 120)
    end

    it 'should return the card' do
      get :learn, :deck_id => @deck.id, :id => @card1.id

      assigns[:card].should == @card1
      UserCardSchedule.where(:user_id => @user.id, :card_id => @card1.id).count.should == 1
    end
  end

  context '"GET" is_new' do
    before(:each) do
      @deck = Deck.make!(:user_id => @user.id)

      @card = Card.make!(:deck_id => @deck.id, :chapter => 1)
    end

    it 'should return false is card does not exist' do
      get :is_new, :deck_id => @deck.id, :id => 0

      assigns[:is_new].should == true
    end

    it 'should return true if user has never reviewed the card before' do
      get :is_new, :deck_id => @deck.id, :id => @card.id

      assigns[:is_new].should == true
    end

    it 'should return false if user has reviewed card before' do
      UserCardReview.make!(:user_id => @user.id, :card_id => @card.id)

      get :is_new, :deck_id => @deck.id, :id => @card.id

      assigns[:is_new].should == false
    end
  end
end
