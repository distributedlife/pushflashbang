# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UsersController do
  context 'index' do
    before(:each) do
      @user = User.make!
      sign_in :user, @user
    end

    it 'should return success' do
      get :index
      
      response.should be_success
    end

    it 'should return all decks for user in alphabetical order' do
      get :index
      assigns[:decks].empty?.should == true

      deck = Deck.make!(:user_id => @user.id, :name => 'my first deck')
      deck = Deck.make!(:user_id => @user.id, :name => 'a second deck')

      get :index
      assigns[:decks].count.should == 2
      assigns[:decks][0].name.should == "a second deck"
      assigns[:decks][1].name.should == "my first deck"
    end

    it 'should return decks created by other users that are shared' do
      deck = Deck.make!(:user_id => @user.id, :name => 'my first deck')
      deck = Deck.make!(:user_id => @user.id + 1, :name => 'a second deck', :shared => true)
      deck = Deck.make!(:user_id => @user.id + 1, :name => 'a third deck', :shared => false)

      get :index
      assigns[:decks].count.should == 2
      assigns[:decks][0].name.should == "a second deck"
      assigns[:decks][1].name.should == "my first deck"
    end

    it 'should return the card count for each deck' do
      deck = Deck.make!(:user_id => @user.id)
      card = Card.make!(:deck_id => deck.id)

      get :index

      assigns[:card_counts][deck.id].should == 1
    end

    it 'should return the due card count for each deck' do
      deck = Deck.make!(:user_id => @user.id)
      card = Card.make!(:deck_id => deck.id)
      scheduled_card = UserCardSchedule.make!(:due, :card_id => card.id, :user_id => @user.id)

      get :index

      assigns[:due_counts][deck.id].should == 1
    end

    it 'should return the languages being learnt by the user' do
      2.times {Language.make!}
      UserLanguages.create(:user_id => @user.id, :language_id => Language.first.id)
      UserLanguages.create(:user_id => 100, :language_id => Language.first.id)

      get :index

      assigns[:languages_user_is_learning].count.should == 1
    end
  end

  context '"PUT" start_editing' do
    before(:each) do
      @user = User.make!
      sign_in :user, @user

      request.env["HTTP_REFERER"] = "http://whereiwasbefore.com"
    end

    it 'should put the user in edit mode' do
      put :stop_editing
      @user.reload
      @user.in_edit_mode?.should be false
      
      put :start_editing

      @user.reload
      @user.in_edit_mode?.should be true
    end
  end

  context '"PUT" stop_editing' do
    before(:each) do
      @user = User.make!
      sign_in :user, @user

      request.env["HTTP_REFERER"] = "http://whereiwasbefore.com"
    end
    
    it 'should take the user out of edit mode' do
      put :start_editing
      @user.reload
      @user.in_edit_mode?.should be true

      put :stop_editing

      @user.reload
      @user.in_edit_mode?.should be false
    end
  end

  context 'flash_messages' do
    before(:each) do
      @user = User.make!
      sign_in :user, @user

      request.env["HTTP_REFERER"] = "http://whereiwasbefore.com"
    end

    it 'should delete session messages when read' do
      session[:warning] = "message"

      get :flash_messages

      session[:warning].nil?.should == true
    end

    it 'should return session messages when set' do
      session[:warning] = "message"

      get :flash_messages, :format => :json

      JSON.parse(response.body)["warning"].should == "message"
    end
  end
end
