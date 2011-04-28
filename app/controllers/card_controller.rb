class CardController < ApplicationController
  before_filter :authenticate_user!

  def new
    begin
      is_deck_valid

      deck = Deck.find(params[:deck_id])

      @card = Card.new
      @card.deck = deck
    rescue
    end
  end

  def create
    begin
      is_deck_valid

      @card = Card.new(params[:card])
      @card.deck = Deck.find(params[:deck_id])

      if @card.valid?
        @card.save!

        flash[:success] = "Card added to deck"
        redirect_to new_deck_card_path(@deck)
      end
    rescue
    end
  end

  def edit
    begin
      is_deck_and_card_valid

      @card = Card.find(params[:id])
    rescue
    end
  end

  def update
    begin
      is_deck_and_card_valid

      card = Card.find(params[:id])
      card.update_attributes(params[:card])

      if card.invalid?
        @card = card
      else
        card.save!
        redirect_to deck_card_path(@deck)
      end
    rescue
    end
  end

  def destroy
    begin
      is_deck_and_card_valid

      Card.delete(params[:id])
      flash[:failure] = "Deck successfully deleted"
    rescue
      flash[:failure] = "Deck successfully deleted"
    end

    redirect_to show_deck_path(params[:deck_id])
  end
  
  def show
    begin
      is_deck_and_card_valid

      @card = Card.find(params[:id])
    rescue
    end
  end

  def reveal
    begin
      is_deck_and_card_valid

      @card = Card.find(params[:id])
    rescue
    end
  end

  def review
    begin
      is_deck_and_card_valid

      answer = params[:answer]

      card_schedule = UserCardSchedule.where(:card_id => params[:id], :user_id => current_user.id)

      if answer == "yes"
        card_schedule.first.interval = CardTiming.get_next(card_schedule.first.interval).seconds
        card_schedule.first.due = Time.now + card_schedule.first.interval
        card_schedule.first.save!
      end
      if answer == "no"
        card_schedule.first.interval = CardTiming.get_first.seconds
        card_schedule.first.due = Time.now + card_schedule.first.interval
        card_schedule.first.save!
      end

      redirect_to learn_deck_path(params[:deck_id])
    rescue
    end
  end

  private
  def is_deck_and_card_valid
    begin
      card = Card.find(params[:id])
      deck = Deck.find(params[:deck_id])

      if deck.user != current_user
        flash[:failure] = "Unable to show card as it does not belong to the user that is currently logged in on this machine."
        redirect_to user_index_path
      end
      if card.deck != deck
        flash[:failure] = "The card does not belong to this deck"
        redirect_to show_deck_path(params[:deck_id])
      end
    rescue
      if card.nil?
        flash[:failure] = "The card no longer exists"
        redirect_to show_deck_path(params[:deck_id])
      else
        flash[:failure] = "The deck no longer exists"
        redirect_to user_index_path
      end
    end
  end

  def is_deck_valid
    begin
      deck = Deck.find(params[:deck_id])

      if deck.user != current_user
        flash[:failure] = "Unable to show card as it does not belong to the user that is currently logged in on this machine."
        redirect_to user_index_path
      end
    rescue
      flash[:failure] = "The deck no longer exists"
      redirect_to user_index_path
    end
  end
end
