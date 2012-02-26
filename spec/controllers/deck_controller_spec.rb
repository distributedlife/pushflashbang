require 'spec_helper'

describe DeckController do
  before(:each) do
    @user = User.make!
    sign_in :user, @user
  end

  shared_examples_for "all deck operations" do
    it 'should redirect to the login page if user is not logged in' do
      sign_out @user

      deck = Deck.make!(:user_id => @user.id)

      get :show, :id => deck.id
      response.should be_redirect
      response.should redirect_to(new_user_session_path)

      sign_in :user, @user
      get :show, :id => deck.id
      response.should be_success
    end
  end
  
  shared_examples_for "all deck operations that require a deck" do
    it 'should redirect to user home if the deck does not belong to the user' do
      user2 = User.make!
      deck = Deck.make!(:user_id => user2.id)

      get :show, :id => deck.id

      response.should be_redirect
      response.should redirect_to(user_index_path)
    end

    it 'should not redirect to user home if the deck does not belong to the user but is shared' do
      user2 = User.make!
      deck = Deck.make!(:user_id => user2.id, :shared => true)

      get :show, :id => deck.id

      response.should_not be_redirect
    end

    it 'should redirect to user home if the deck does not exist' do
      get :show, :id => 100

      response.should be_redirect
      response.should redirect_to(user_index_path)
    end
  end

  context '"GET" create' do
    it_should_behave_like "all deck operations"
  end

  context '"POST" create' do
    it_should_behave_like "all deck operations"

    it 'should return a newly created object' do
      post :create, :deck => {:name => "My new deck"}

      assigns[:deck].name.should == "My new deck"
      assigns[:deck].user.should == @user
      assigns[:deck].pronunciation_side.should == 'front'
    end

    it 'should redirect to the deck page' do
      post :create, :deck => {:name => "My new deck"}

      response.should be_redirect
      response.should redirect_to(show_deck_path(Deck.last.id))
    end

    it 'should have flash message indicating successful deck creation' do
      post :create, :deck => {:name => "My new deck"}

      session[:success].should ~ /^Deck successfully created/
    end

    it 'should require all mandatory fields' do
      post :create, :deck => {}

      assigns[:deck].errors[:name].should == ["can't be blank"]
    end
  end

  context '"GET" edit' do
    it_should_behave_like "all deck operations that require a deck"

    it 'should return the deck for the given id' do
      deck = Deck.make!(:user_id => @user.id)

      get :edit, :id => deck.id

      assigns[:deck].should == deck
    end
  end

  context '"PUT" update' do
    it_should_behave_like "all deck operations that require a deck"

    it 'should update the deck for the given id' do
      deck = Deck.make!(:user_id => @user.id)

      put :update, :id => deck.id, :deck => {:id => deck.id, :name => "edited name", :description => 'edited description'}

      deck.reload
      deck.name.should == "edited name"
      deck.description.should == "edited description"

      response.should redirect_to(show_deck_path(deck.id))
    end

    it 'should not update the user attribute' do
      user2 = User.make!

      deck = Deck.make!(:user_id => @user.id)

      put :update, :id => deck.id, :deck => {:user => user2, :name => "edited name", :description => 'edited description'}

      response.should be_redirect
      deck.reload
      deck.name.should == "edited name"
      deck.description.should == "edited description"
      deck.user.should == @user
    end

    it 'should not update if the deck is made invalid' do
      deck = Deck.make!(:user_id => @user.id, :name => 'my deck', :description => nil)

      put :update, :id => deck.id, :deck => {:id => deck.id, :name => "", :description => 'edited description'}

      deck.reload
      deck.name.should == "my deck"
      deck.description.should == nil

      assigns[:deck].name.should == ""
      assigns[:deck].description.should == "edited description"
      assigns[:deck].user.should == @user
    end
  end

  context '"GET" show' do
    it_should_behave_like "all deck operations that require a deck"

    it 'should return the deck for the given id' do
      deck = Deck.make!(:user_id => @user.id)

      get :show, :id => deck.id

      assigns[:deck].should == deck
    end

    it 'should return the chapters for the given deck' do
      deck = Deck.make!(:user_id => @user.id)

      card1 = Card.make!(:deck_id => deck.id, :front => 'vvv', :chapter => 1)
      Card.make!(:deck_id => deck.id, :front => 'aaa', :chapter => 2)

      card1.front = 'zzz'
      card1.save!

      get :show, :id => deck.id

      assigns[:deck].should == deck
      assigns[:chapters][0].chapter.should == 1
      assigns[:chapters][1].chapter.should == 2
    end

    it 'should return a shared deck beloning to another user' do
      user2 = User.make!

      deck = Deck.make!(:user_id => user2.id, :shared => true)

      get :show, :id => deck.id

      assigns[:deck].should == deck
    end
  end

  context '"DELETE" destroy' do
    it_should_behave_like "all deck operations that require a deck"

    it 'should delete the deck for the given id' do
      deck = Deck.make!(:user_id => @user.id)

      delete :destroy, :id => deck.id

      Deck.count.should == 0
      response.should be_redirect
      response.should redirect_to(user_index_path)
    end

    it 'should not delete the deck if the id does not belong to the user' do
      user2 = User.make!

      deck = Deck.make!(:user_id => user2.id)

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

    it 'should delete all cards and card schedule and not delete the reviews' do
      deck = Deck.make!(:user_id => @user.id)

      card1 = Card.make!(:deck_id => deck.id)
      card2 = Card.make!(:deck_id => deck.id)
      UserCardSchedule.make!(:card_id => card1.id, :user_id => @user.id)
      UserCardSchedule.make!(:card_id => card2.id, :user_id => @user.id)
      UserCardReview.make!(:card_id => card1.id, :user_id => @user.id)
      UserCardReview.make!(:card_id => card2.id, :user_id => @user.id)
      UserDeckChapter.make!(:deck_id => deck.id, :user_id => @user.id)

      delete :destroy, :id => deck.id

      response.should be_redirect
      response.should redirect_to(user_index_path)
      Deck.count.should == 0
      Card.count.should == 0
      UserCardSchedule.count.should == 0
      UserCardReview.count.should == 2
      UserDeckChapter.count.should == 0
    end
  end

  context "'GET' learn" do
    it_should_behave_like "all deck operations that require a deck"

    before(:each) do
      @deck = Deck.make!(:user_id => @user.id)

      @card1 = Card.make!(:deck_id => @deck.id, :chapter => 1)
      @card2 = Card.make!(:deck_id => @deck.id, :chapter => 1)
      @card3 = Card.make!(:deck_id => @deck.id, :chapter => 1)

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

        UserCardSchedule.first.user_id.should == @user.id
        UserCardSchedule.first.card_id.should == @card1.id
        UserCardSchedule.first.due.should >= start_of_test
        UserCardSchedule.first.due.should <= Time.now
        UserCardSchedule.first.interval.should == 0

        UserCardSchedule.count.should == 1
      end

      it 'should create a user chapter mark at 1' do
        get :learn, :id => @deck.id

        UserDeckChapter.where(:deck_id => @deck.id, :user_id => @user.id, :chapter => 1).count.should == 1
      end

      it 'should redirect to the character learn page' do
        get :learn, :id => @deck.id

        response.should be_redirect
        response.should redirect_to(learn_deck_card_path(@deck.id, @card1.id))
      end
    end

    context "user has cards due" do
      it 'should redirect to the character learn page of the first card due' do
        UserCardSchedule.make!(:user_id => @user.id, :card_id => @card1.id, :due => 1.day.ago)
        UserCardSchedule.make!(:user_id => @user.id, :card_id => @card2.id, :due => 2.days.ago)
        UserCardSchedule.make!(:user_id => @user.id, :card_id => @card3.id, :due => 3.days.ago)

        get :learn, :id => @deck.id

        response.should be_redirect
        response.should redirect_to(learn_deck_card_path(@deck.id, @card3.id))
      end
    end

    context "user has no cards due" do
      it 'should redirect to the character learn page of the next card due' do
        UserCardSchedule.make!(:user_id => @user.id, :card_id => @card1.id, :due => 1.day.from_now)
        UserCardSchedule.make!(:user_id => @user.id, :card_id => @card3.id, :due => 2.days.from_now)

        get :learn, :id => @deck.id

        response.should be_redirect
        response.should redirect_to(learn_deck_card_path(@deck.id, @card2.id))
      end

      it 'should redirect to next_chapter if the scheduled card is the next chapter' do
        @card2.chapter = 2
        @card2.save!

        UserCardSchedule.make!(:user_id => @user.id, :card_id => @card1.id, :due => 1.day.from_now)
        UserCardSchedule.make!(:user_id => @user.id, :card_id => @card3.id, :due => 1.day.from_now)

        get :learn, :id => @deck.id

        response.should be_redirect
        response.should redirect_to(deck_chapter_path(@deck.id, @card2.chapter))
      end

      it 'should redirect to upcoming cards view if there are no cards to schedule' do
        UserCardSchedule.make!(:user_id => @user.id, :card_id => @card3.id, :due => 1.day.from_now)
        UserCardSchedule.make!(:user_id => @user.id, :card_id => @card2.id, :due => 1.day.from_now)
        UserCardSchedule.make!(:user_id => @user.id, :card_id => @card1.id, :due => 2.days.from_now)

        get :learn, :id => @deck.id

        response.should be_redirect
        response.should redirect_to(upcoming_deck_path(@deck.id))
      end
    end
  end

  context "'GET' toggle_share" do
    it_should_behave_like "all deck operations that require a deck"

    before(:each) do
      @deck = Deck.make!(:user_id => @user.id)
    end

    it 'should redirect show deck' do
      get :toggle_share, :id => @deck.id

      response.should be_redirect
      response.should redirect_to(deck_path(@deck.id))
    end

    it 'should share if deck is not shared' do
      get :toggle_share, :id => @deck.id

      @deck.reload
      @deck.shared.should == true
    end

    it 'should stop sharing a deck if is shared' do
      @deck.shared = true
      @deck.save!

      get :toggle_share, :id => @deck.id

      @deck.reload
      @deck.shared.should == false
    end
  end

  context '"GET" cards_due' do
    before(:each) do
      @deck = Deck.make!(:user_id => @user.id)

      @card1 = Card.make!(:deck_id => @deck.id, :chapter => 1)
      @card2 = Card.make!(:deck_id => @deck.id, :chapter => 1)
      @card3 = Card.make!(:deck_id => @deck.id, :chapter => 1)
    end

    it 'should return 0 if no cards are due' do
      get :due_count, :id => @deck.id

      assigns[:due_count].should == 0
    end

    it 'should return the number of cards due including the current card' do
      UserCardSchedule.make!(:user_id => @user.id, :card_id => @card1.id, :due => 1.day.ago)
      UserCardSchedule.make!(:user_id => @user.id, :card_id => @card2.id, :due => 2.days.ago)
      UserCardSchedule.make!(:user_id => @user.id, :card_id => @card3.id, :due => 1.day.from_now)

      get :due_count, :id => @deck.id

      assigns[:due_count].should == 2
    end
  end

  context "'GET' upcoming" do
    it_should_behave_like "all deck operations that require a deck"

    before(:each) do
      @user = User.make!
    sign_in :user, @user

    @deck = Deck.make!(:user_id => @user.id)

    @card1 = Card.make!(:deck_id => @deck.id, :chapter => 1)
    @card2 = Card.make!(:deck_id => @deck.id, :chapter => 2)
    @card3 = Card.make!(:deck_id => @deck.id, :chapter => 3)

    @user_card_schedule = UserCardSchedule.make!(:user_id => @user.id, :card_id => @card1.id, :due => 1.day.from_now)

    UserDeckChapter.make!(:user_id => @user.id, :deck_id => @deck.id)

    CardTiming.create(:seconds => 5)
    CardTiming.create(:seconds => 25)
    CardTiming.create(:seconds => 120)
    end

    it 'should return upcoming cards if there are no cards to schedule' do
      get :upcoming, :id => @deck.id

      assigns[:upcoming_cards].count.should == UserCardSchedule.where(:user_id => @user.id).count

      assigns[:upcoming_cards].first["front"].nil?.should == false
      assigns[:upcoming_cards].first["back"].nil?.should == false
      assigns[:upcoming_cards].first["due"].nil?.should == false
      assigns[:upcoming_cards].first["id"].nil?.should == false
    end

    it 'should redirect to deck/learn if there are still due cards' do
      @user_card_schedule.due = 1.day.ago
      @user_card_schedule.save!

      get :upcoming, :id => @deck.id

      response.should be_redirect
      response.should redirect_to(learn_deck_path(@deck.id))
    end
  end

  context '"GET" index' do
    it 'should redirect to the login page if user is not logged in' do
      sign_out @user

      deck = Deck.make!(:user_id => @user.id)

      get :index
      response.should be_redirect
      response.should redirect_to(new_user_session_path)

      sign_in :user, @user
      get :index
      response.should be_success
    end

    it 'should return all the decks belonging to the user' do
      deck1 = Deck.make!(:user_id => @user.id)
      deck2 = Deck.make!(:user_id => @user.id)
      deck3 = Deck.make!(:user_id => @user.id + 100)

      get :index

      assigns[:decks].count.should == 2
      assigns[:decks].include?(deck1).should == true
      assigns[:decks].include?(deck2).should == true
      assigns[:decks].include?(deck3).should == false
    end
    
    it 'should return all shared decks' do
      deck1 = Deck.make!(:user_id => @user.id)
      deck2 = Deck.make!(:user_id => @user.id)
      deck3 = Deck.make!(:user_id => @user.id + 100, :shared => true)

      get :index

      assigns[:decks].count.should == 3
      assigns[:decks].include?(deck1).should == true
      assigns[:decks].include?(deck2).should == true
      assigns[:decks].include?(deck3).should == true
    end
  end
end