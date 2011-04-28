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

  def learn
    begin
      is_deck_valid

      #if there are no cards in deck; we should not try and schedule any
      cards = Card.order(:created_at).where(:deck_id => params[:id])
      if cards.empty?
        flash[:failure] = "You can't start a session until you have added cards to the deck."
        redirect_to deck_path(params[:id])
        return
      end

      #get next scheduled card for user
      @scheduled_card = UserCardSchedule::get_next_due_for_user(current_user.id)
      @due_count = UserCardSchedule::get_due_count_for_user(current_user.id)

      #if there are no scheduled cards for the user; get the first card in the deck that has not been scheduled and schedule it
      if @scheduled_card.nil?
        @scheduled_card = UserCardSchedule.new(:user_id => current_user.id, :due => Time.now, :interval => CardTiming.get_first.seconds)

        cards = Card.find_by_sql("SELECT * FROM cards where deck_id = #{params[:id]} and id not in (select card_id from user_card_schedules where user_id = #{current_user.id}) order by created_at asc")

        if cards.empty?
          @card = nil
          @scheduled_card = nil

          @upcoming_cards = ActiveRecord::Base.connection.execute("SELECT cards.id, cards.front, cards.back, user_card_schedules.due FROM cards, user_card_schedules where deck_id = #{params[:id]} and cards.id = user_card_schedules.card_id and user_id = #{current_user.id} order by due asc")
        else
          @card = cards[0]
          @scheduled_card.card_id = @card.id
          @scheduled_card.save!
        end
      else
        @card = Card.find(@scheduled_card.card_id)
      end
    rescue
    end
  end

  private
  def is_deck_valid
    begin
      deck = Deck.find(params[:id])

      if deck.user != current_user
        flash[:failure] = "Unable to show deck as it does not belong to the user that is currently logged in on this machine."
        redirect_to user_index_path
      end
    rescue
      flash[:failure] = "The deck no longer exists"
      redirect_to user_index_path
    end
  end
end
