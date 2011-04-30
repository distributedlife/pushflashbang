class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @decks = Deck.order(:name).where("user_id = ? OR shared = ?", current_user.id, true)
    card_counts = Card.find_by_sql(["SELECT deck_id, count(deck_id) FROM cards where deck_id in (SELECT id from decks where user_id = ? OR shared = ?) group by deck_id", current_user.id, true])

    @card_counts = []
    card_counts.each do |count|
      @card_counts[count['deck_id']] = count['count(deck_id)']
    end

    @due_counts = []
    @decks.each do |deck|
      @due_counts[deck.id] = UserCardSchedule.get_due_count_for_user_for_deck current_user.id, deck.id
    end
  end
end
