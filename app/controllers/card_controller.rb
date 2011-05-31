class CardController < ApplicationController
  before_filter :authenticate_user!

  caches_page :learn

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

      expire_page(:controller => 'card', :action => 'learn', :id => params[:id])
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
#    begin
      if is_deck_and_card_valid_and_user_is_owner?
        UserCardSchedule.where(:card_id => params[:id]).each do |card_schedule|
          card_schedule.delete
        end

        Card.delete(params[:id])
        flash[:failure] = "Deck successfully deleted"
        redirect_to show_deck_path(params[:deck_id])
#      else
#        flash[:failure] = "Deck successfully deleted"
      end
#    rescue
#    end

  end
  
  def show
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

#      if params[:review_start].nil?
#        params[:review_start] = Time.now
#      else
#        params[:review_start] = Time.parse(params[:review_start])
#      end

      params[:duration] ||= 0
      params[:elapsed] ||= 0
      duration_in_seconds = params[:duration].to_i / 1000
      elapsed_in_seconds = params[:elapsed].to_i / 1000


      card_schedule = UserCardSchedule.where(:card_id => params[:id], :user_id => current_user.id)
      card_schedule = card_schedule.first

      #review start time is now - elapsed where it can't be less than the due time
      review_start_time = Time.now - elapsed_in_seconds < card_schedule.due ? card_schedule.due : Time.now - elapsed_in_seconds


      user_card_review = UserCardReview.new(
        :card_id => params[:id],
        :user_id => current_user.id,
#        :review_start => params[:review_start],
        :review_start => review_start_time,
        :reveal => review_start_time + duration_in_seconds,
        :result_recorded => Time.now,
        :result_success => answer
        )


      user_card_review.due = card_schedule.due
      user_card_review.interval = card_schedule.interval

      if answer == "shaky_good"
        card_schedule.interval = CardTiming.get_next(card_schedule.interval).seconds
        card_schedule.due = Time.now + card_schedule.interval
        card_schedule.save!

        user_card_review.save!
      end
      if answer == "good"
        card_schedule.interval = CardTiming.get_next(CardTiming.get_next(card_schedule.interval).seconds).seconds
        card_schedule.due = Time.now + card_schedule.interval
        card_schedule.save!

        user_card_review.save!
      end
      if answer == "didnt_know" || answer == "partial_correct"
        card_schedule.interval = CardTiming.get_first.seconds
        card_schedule.due = Time.now + card_schedule.interval
        card_schedule.save!

        user_card_review.save!
      end

      redirect_to learn_deck_path(params[:deck_id])
    rescue
    end
  end

  def learn
    begin
      is_deck_and_card_valid

      @deck = Deck.find(params[:deck_id])
      @card = Card.find(params[:id])

      #create a scheduled card entry if one does not exist
      scheduled_card = UserCardSchedule::where(:user_id => current_user.id, :card_id => params[:id])
      if scheduled_card.empty?
        scheduled_card = UserCardSchedule.create(:user_id => current_user.id, :card_id => params[:id], :due => Time.now, :interval => 0)
      end

      session[:review_start] = Time.now
    rescue
    end
  end

  def is_new
    reviews_of_card = UserCardReview::where(:user_id => current_user.id, :card_id => params[:id]).count

    @is_new = reviews_of_card == 0

    respond_to do |format|
      format.json { render :json => @is_new}
    end
  end

  private
  def is_deck_and_card_valid
    begin
      card = Card.find(params[:id])
      deck = Deck.find(params[:deck_id])

      if deck.user != current_user && deck.shared == false
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

  def is_deck_and_card_valid_and_user_is_owner?
    begin
      card = Card.find(params[:id])
      deck = Deck.find(params[:deck_id])
#ap card
#ap deck
      if deck.user != current_user
        flash[:failure] = "Unable to complete action as this deck does not belong to you."
        redirect_to user_index_path
#ap 'is not owner'
        return false
      end
      if card.deck != deck
        flash[:failure] = "The card does not belong to this deck"
        redirect_to show_deck_path(params[:deck_id])

        return false
      end

      true
    rescue
      if card.nil?
        flash[:failure] = "The card no longer exists"
        redirect_to show_deck_path(params[:deck_id])

        return false
      else
        flash[:failure] = "The deck no longer exists"
        redirect_to user_index_path

        return false
      end
    end
  end

  def is_deck_valid
    begin
      deck = Deck.find(params[:deck_id])

      if deck.user != current_user && deck.shared == false
        flash[:failure] = "Unable to show card as it does not belong to the user that is currently logged in on this machine."
        redirect_to user_index_path
      end
    rescue
      flash[:failure] = "The deck no longer exists"
      redirect_to user_index_path
    end
  end
end
