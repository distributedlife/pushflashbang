class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @decks = Deck.order(:name).where("user_id = ? OR shared = ?", current_user.id, true)
  end
end
