class DeckController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    @deck = Deck.new(params[:deck])
    @deck.user = current_user

    if @deck.valid?
      @deck.save!

      flash[:success] = "Deck successfully created!"
      redirect_to show_deck_path(@deck)
    end
  end

  def edit
    begin
      @deck = Deck.find(params[:id])

      if @deck.user != current_user
        flash[:failure] = "Unable to show deck as it does not belong to the user that is currently logged in on this machine."
        redirect_to user_index_path
      end
    rescue
      flash[:failure] = "Could not find deck."
      redirect_to user_index_path
    end
  end

  def update
    begin
      deck = Deck.find(params[:id])

      if deck.user == current_user
        deck.update_attributes(params[:deck])

        if deck.invalid?
          @deck = deck          
        else
          deck.save!
          redirect_to show_deck_path(@deck)
        end
      else
        flash[:failure] = "Unable to update deck as it does not belong to the user that is currently logged in on this machine."
        redirect_to user_index_path
      end
    rescue
      redirect_to user_index_path
    end
  end

  def show
    begin
      @deck = Deck.find(params[:id])

      if @deck.user != current_user
        flash[:failure] = "Unable to show deck as it does not belong to the user that is currently logged in on this machine."
        redirect_to user_index_path
      end

      @cards = Card.where(:deck_id => params[:id])
    rescue
      flash[:failure] = "Could not find deck."
      redirect_to user_index_path
    end
  end

  def destroy
    begin
      deck = Deck.find(params[:id])

      if deck.user == current_user
        Deck.delete(params[:id])
        flash[:failure] = "Deck successfully deleted"
      else
        flash[:failure] = "Unable to delete deck as it does not belong to the user that is currently logged in on this machine."
      end
    rescue
      flash[:failure] = "Deck successfully deleted"
    end
    
    redirect_to user_index_path
  end
end
