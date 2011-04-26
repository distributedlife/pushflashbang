class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @decks = Deck::order(:name).where(:user_id => current_user.id)
  end
end
