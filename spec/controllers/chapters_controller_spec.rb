require 'spec_helper'

describe ChaptersController do
  before(:each) do
    @user = User.make
    sign_in :user, @user
    
    @deck = Deck.make(:user_id => @user.id)

    @card1 = Card.make(:deck_id => @deck.id, :chapter => 1)
    @card2 = Card.make(:deck_id => @deck.id, :chapter => 2)
    @card3 = Card.make(:deck_id => @deck.id, :chapter => 3)

    @user_card_schedule = UserCardSchedule.make(:user_id => @user.id, :card_id => @card1.id, :due => 1.day.from_now)

    UserDeckChapter.make(:user_id => @user.id, :deck_id => @deck.id)

    CardTiming.create(:seconds => 5)
    CardTiming.create(:seconds => 25)
    CardTiming.create(:seconds => 120)
  end

  shared_examples_for "all chapter operations that require a deck" do
    it 'should redirect to user home if the deck does not belong to the user' do
      user2 = User.make
      deck = Deck.make(:user_id => user2.id)

      get :show, :deck_id => deck.id, :id => 1

      response.should be_redirect
      response.should redirect_to(user_index_path)
    end

    it 'should not redirect to user home if the deck does not belong to the user but is shared' do
      user2 = User.make
      deck = Deck.make(:user_id => user2.id, :shared => true)
      card = Card.make(:deck_id => deck.id)

      get :show, :deck_id => deck.id, :id => 1

      response.should_not be_redirect
    end

    it 'should redirect to user home if the deck does not exist' do
      get :show, :deck_id => 100, :id => 1

      response.should be_redirect
      response.should redirect_to(user_index_path)
    end
  end

  context "'GET show" do
    it_should_behave_like "all chapter operations that require a deck"
    
    it 'should return upcoming cards if there are no cards to schedule' do
      get :show, :deck_id => @deck.id, :id => 1

      assigns[:upcoming_cards].count.should == UserCardSchedule.where(:user_id => @user.id).count

      assigns[:upcoming_cards].first["front"].nil?.should == false
      assigns[:upcoming_cards].first["back"].nil?.should == false
      assigns[:upcoming_cards].first["due"].nil?.should == false
      assigns[:upcoming_cards].first["id"].nil?.should == false
    end

    it 'should redirect to deck/learn if there are still due cards' do
      @user_card_schedule.due = 1.day.ago
      @user_card_schedule.save!

      get :show, :deck_id => @deck.id, :id => 1

      response.should be_redirect
      response.should redirect_to(learn_deck_path(@deck.id))
    end
  end

  context "'GET' advance" do
    it_should_behave_like "all chapter operations that require a deck"

    it 'should increment the chapter for the user and deck pair' do
      @user_deck_chapter = UserDeckChapter.where(:user_id => @user.id, :deck_id => @deck.id).first
      @user_deck_chapter.chapter.should == 1

      get :advance, :deck_id => @deck.id, :id => 1

      @user_deck_chapter.reload
      @user_deck_chapter.chapter.should == 2
    end

    it 'should skip to the chapter of the next unscheduled card for the user and deck pair' do
      @user_deck_chapter = UserDeckChapter.where(:user_id => @user.id, :deck_id => @deck.id).first
      @user_deck_chapter.chapter.should == 1

      UserCardSchedule.make(:user_id => @user.id, :card_id => @card2.id, :due => 1.day.from_now)


      get :advance, :deck_id => @deck.id, :id => 1

      @user_deck_chapter.reload
      @user_deck_chapter.chapter.should == 3
    end

    it 'should not increment the chapter more than the highest chapter in the deck' do
      @user_deck_chapter = UserDeckChapter.where(:user_id => @user.id, :deck_id => @deck.id).first
      @user_deck_chapter.chapter = 3
      @user_deck_chapter.save!

      get :advance, :deck_id => @deck.id, :id => 3

      @user_deck_chapter.reload
      @user_deck_chapter.chapter.should == 3
    end

    it 'should redirect to deck/learn' do
      get :advance, :deck_id => @deck.id, :id => 1

      response.should be_redirect
      response.should redirect_to(learn_deck_path(@deck.id))
    end

    it 'should redirect to deck/learn if user has no chapter' do
      UserDeckChapter.delete_all
      
      get :advance, :deck_id => @deck.id, :id => 1

      response.should be_redirect
      response.should redirect_to(learn_deck_path(@deck.id))
    end
  end

  context '"GET" cram' do
    it_should_behave_like "all chapter operations that require a deck"

    it 'should redirect to the deck home if no cards in the deck' do
      get :cram, :deck_id => @deck.id, :id => 4
      
      response.should be_redirect
      response.should redirect_to(deck_path(@deck.id))
    end

    it 'should redirect to the first card in the chapter if the card_id is not supplied' do
      get :cram, :deck_id => @deck.id, :id => 1

      response.should be_redirect
      response.should redirect_to(cram_deck_card_path(@deck.id, @card1.id))
    end

    it 'should redirect to each card in the chapter based on the last card' do
      card12 = Card.make(:deck_id => @deck.id, :chapter => 1)
      card13 = Card.make(:deck_id => @deck.id, :chapter => 1)
      card14 = Card.make(:deck_id => @deck.id, :chapter => 1)
      card15 = Card.make(:deck_id => @deck.id, :chapter => 1)

      get :cram, :deck_id => @deck.id, :id => 1, :card_id => @card1.id
      response.should redirect_to(cram_deck_card_path(@deck.id, card12.id))

      get :cram, :deck_id => @deck.id, :id => 1, :card_id => card12.id
      response.should redirect_to(cram_deck_card_path(@deck.id, card13.id))

      get :cram, :deck_id => @deck.id, :id => 1, :card_id => card13.id
      response.should redirect_to(cram_deck_card_path(@deck.id, card14.id))

      get :cram, :deck_id => @deck.id, :id => 1, :card_id => card14.id
      response.should redirect_to(cram_deck_card_path(@deck.id, card15.id))
    end

    it 'should redirect to the deck home once all cards have been shown' do
      get :cram, :deck_id => @deck.id, :id => 1, :card_id => @card1.id

      response.should be_redirect
      response.should redirect_to(deck_path(@deck.id))
    end
  end
end
