# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Deck do
  context 'to be valid' do
    before(:each) do
      @user = User.make!
    end

    it 'should be associated with a user' do
      deck = Deck.new(:name => 'name', :description => 'something', :pronunciation_side => Deck::SIDES[0])

      deck.valid?.should == false
      deck.user = @user
      deck.valid?.should == true
    end

    it 'should require a name' do
      deck = Deck.new(:description => 'something', :pronunciation_side => Deck::SIDES[0])
      deck.user = @user

      deck.valid?.should == false
      deck.name = 'something'
      deck.valid?.should == true
    end

    it 'should default shared to false' do
      deck = Deck.new(:name => 'name', :description => 'something', :pronunciation_side => Deck::SIDES[0])
      deck.user = @user

      deck.valid?.should == true
      deck.shared = false
    end

    it 'should default support written answer to false' do
      deck = Deck.new(:name => 'name', :description => 'something', :pronunciation_side => Deck::SIDES[0])
      deck.user = @user

      deck.valid?.should == true
      deck.supports_written_answer = false
    end

    it 'should require a pronunciation side' do
      deck = Deck.new(:name => 'something')
      deck.user = @user

      deck.valid?.should == false
      deck.pronunciation_side = 'front'
      deck.valid?.should == true
    end

    it 'should be invalid if pronunciation_side is not in allowed list' do
      deck = Deck.new(:name => 'something')
      deck.user = @user

      deck.valid?.should be false

      Deck::SIDES.each do |side|
        deck.pronunciation_side = side
        deck.valid?.should == true
        deck.errors.empty?.should == true
      end

      deck.pronunciation_side = 'banana'
      deck.valid?.should == false
    end
  end

  context 'review types' do
    it 'should allow no review type' do
      deck = Deck.make!
      deck.review_types = 0
      deck.save!
      deck.reload

      deck.review_types.should == 0
    end

    it 'should allow a single review type' do
      deck = Deck.make!
      deck.review_types = Deck::READING
      deck.save!
      deck.reload

      deck.review_types.should == Deck::READING
    end

    it 'should allow an array of review types' do
      deck = Deck.make!
      deck.review_types = Deck::READING
      deck.review_types = deck.review_types | Deck::WRITING
      deck.save!
      deck.reload
      
      deck.review_types.should == Deck::READING | Deck::WRITING
    end
  end

  context 'delete' do
    before(:each) do
      @user = User.make!
    end
    
    it 'should delete the deck' do
      Deck.count.should be 0

      deck = Deck.make!(:user_id => @user.id)
      Deck.count.should be 1

      deck.delete

      Deck.count.should be 0
    end

    it 'should delete any user deck chapters' do
      UserDeckChapter.count.should be 0

      deck = Deck.make!(:user_id => @user.id)
      UserDeckChapter.make!(:deck_id => deck.id, :user_id => 1)
      UserDeckChapter.make!(:deck_id => deck.id, :user_id => 2)
      UserDeckChapter.count.should be 2

      deck.delete

      UserDeckChapter.count.should be 0
    end

    it 'should delete the card' do
      Card.count.should be 0

      deck = Deck.make!(:user_id => @user.id)
      Card.make!(:deck_id => deck.id)
      Card.make!(:deck_id => deck.id)
      Card.make!(:deck_id => deck.id)
      Card.make!(:deck_id => deck.id)
      Card.count.should be 4

      deck.delete

      Card.count.should be 0
    end
  end

  context 'get_chapters' do
    before(:each) do
      @user = User.make!
      @deck = Deck.make!(:user_id => @user.id)
    end

    it 'should return nil if there are no cards in the deck' do
      @deck.get_chapters.empty?.should be true
    end

    it 'should return an array object for each chapter in the deck' do
      Card.make!(:deck_id => @deck.id, :chapter => 1)
      Card.make!(:deck_id => @deck.id, :chapter => 2)
      Card.make!(:deck_id => @deck.id, :chapter => 4)
      Card.make!(:deck_id => @deck.id, :chapter => 8)

      chapters = @deck.get_chapters
      chapters[0].chapter.should be 1
      chapters[1].chapter.should be 2
      chapters[2].chapter.should be 4
      chapters[3].chapter.should be 8

      chapters.count.should be 4
    end
  end

  context 'get_visible_decks_for_user' do
    before(:each) do
      @user1 = User.make!
      @user2 = User.make!

      @shared_deck = Deck.make!(:user_id => @user2.id, :shared => true)
      @other_user_deck = Deck.make!(:user_id => @user2.id, :shared => false)
      @my_deck = Deck.make!(:user_id => @user1.id)
    end

    it 'should return all decks the user owns' do
      Deck.get_visible_decks_for_user(@user1.id).include?(@my_deck).should == true
    end

    it 'should return all shared decks' do
      Deck.get_visible_decks_for_user(@user1.id).include?(@shared_deck).should == true
      Deck.get_visible_decks_for_user(@user1.id).include?(@other_user_deck).should == false
    end
  end

  context 'cards' do
    it 'should return all cards in the deck' do
      deck1 = Deck.make!
      deck2 = Deck.make!
      card1 = Card.make!(:deck_id => deck1.id)
      card2 = Card.make!(:deck_id => deck2.id)

      deck1.cards.include?(card1).should == true
      deck1.cards.include?(card2).should == false
    end
  end
end
