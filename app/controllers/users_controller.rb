# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => :flash_messages

  def flash_messages
    messages = {}
    messages["success"] = session[:success] unless session[:success].nil?
    messages["error"] = session[:error] unless session[:error].nil?
    messages["warning"] = session[:warning] unless session[:warning].nil?
    messages["info"] = session[:info] unless session[:info].nil?
    session.delete :success
    session.delete :warning
    session.delete :error
    session.delete :info

    respond_to do |format|
      format.json { render :json => messages}
    end
  end

  def index
    @decks = Deck.get_visible_decks_for_user current_user.id

    @card_counts = []
    @decks.each do |deck|
      @card_counts[deck.id] = Deck.find(deck.id).cards.count
    end

    @due_counts = []
    @decks.each do |deck|
      @due_counts[deck.id] = UserCardSchedule.get_due_count_for_user_for_deck current_user.id, deck.id
    end

    @languages_user_is_learning = current_user.languages
  end

  def start_editing
    current_user.start_editing

    info_redirect_to t('notice.start-editing'), :back
  end

  def stop_editing
    current_user.stop_editing

    info_redirect_to t('notice.stop-editing'), :back
  end
end
