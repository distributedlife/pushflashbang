class DeckController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    unless (params[:deck].nil?)

      params[:deck][:user] = current_user
      @deck = Deck.create(params[:deck])
    else
      @deck = Deck.new(:user => current_user)
    end

    if @deck.valid?
      redirect_to deck_show_path(@deck)
    end
  end
end
