class UsersController < ApplicationController
  before_filter :authenticate_user!

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
  end
end
