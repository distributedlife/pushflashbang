class UsersController < ApplicationController
  before_filter :authenticate_user!

  caches_page :index

  def index
    @decks = Deck.order(:name).where("user_id = ? OR shared = ?", current_user.id, true)

    @card_counts = []
    @decks.each do |deck|
      @card_counts[deck.id] = Card.where(:deck_id => deck.id).count
    end

    @due_counts = []
    @decks.each do |deck|
      @due_counts[deck.id] = UserCardSchedule.get_due_count_for_user_for_deck current_user.id, deck.id
    end

    #get user languages
    @user_languages = UserLanguages.joins(:language).where(:user_id => current_user.id)
  end

  def start_editing
    current_user.start_editing

    redirect_to :back
  end

  def stop_editing
    current_user.stop_editing

    redirect_to :back
  end
end
