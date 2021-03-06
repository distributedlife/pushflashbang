# -*- encoding : utf-8 -*-
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

        success_redirect_to t('notice.card-add'), new_deck_card_path(@deck)
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

        expire_page(:controller => 'card', :action => 'learn', :id => params[:id])

        success_redirect_to t('notice.card-update'), deck_card_path(@deck)
      end
    rescue
    end
  end

  def destroy
    if is_deck_and_card_valid_and_user_is_owner?
      card = Card.find(params[:id])
      card.delete

      success_redirect_to t('notice.card-delete'), show_deck_path(params[:deck_id])
    end
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

      params[:duration] ||= 0
      params[:elapsed] ||= 0
      duration_in_seconds = params[:duration].to_i / 1000
      elapsed_in_seconds = params[:elapsed].to_i / 1000


      card_schedule = UserCardSchedule.where(:card_id => params[:id], :user_id => current_user.id)
      card_schedule = card_schedule.first

      review_start_time = Time.now - elapsed_in_seconds < card_schedule.due ? card_schedule.due : Time.now - elapsed_in_seconds


      user_card_review = UserCardReview.new(
        :card_id => params[:id],
        :user_id => current_user.id,
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
        skipped_interval = CardTiming.get_next_no_random(card_schedule.interval).seconds

        card_schedule.interval = CardTiming.get_next_advance(skipped_interval).seconds
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


      #for each review type that the deck supports; update the original and create new reviews
      deck = Deck.find(params[:deck_id])
      updated_first = false
      Deck::REVIEW_TYPES.each do |review_type|
        if deck.review_types & review_type == review_type
          unless updated_first
            user_card_review.review_type = review_type
            user_card_review.save
            updated_first = true
          else
            additional_review = user_card_review.dup
            additional_review.review_type = review_type
            additional_review.save
          end
        end
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

      if detect_browser == "mobile_application"
        render "learn.mobile"
      end
    rescue
    end
  end

  def cram
    begin
      is_deck_and_card_valid

      @deck = Deck.find(params[:deck_id])
      @card = Card.find(params[:id])
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
        error_redirect_to t('notice.not-authorised'), user_index_path
      end
      if card.deck != deck
        error_redirect_to t('notice.not-found'), show_deck_path(params[:deck_id])
      end
    rescue
      if card.nil?
        error_redirect_to t('notice.not-found'), show_deck_path(params[:deck_id])
      else
        error_redirect_to t('notice.not-found'), user_index_path
      end
    end
  end

  def is_deck_and_card_valid_and_user_is_owner?
    begin
      card = Card.find(params[:id])
      deck = Deck.find(params[:deck_id])

      if deck.user != current_user
        error_redirect_to t('notice.not-authorised'), user_index_path
        return false
      end
      if card.deck != deck
        error_redirect_to t('notice.not-found'), show_deck_path(params[:deck_id])

        return false
      end

      true
    rescue
      if card.nil?
        error_redirect_to t('notice.not-found'), show_deck_path(params[:deck_id])

        return false
      else
        error_redirect_to t('notice.not-found'), user_index_path

        return false
      end
    end
  end

  def is_deck_valid
    begin
      deck = Deck.find(params[:deck_id])

      if deck.user != current_user && deck.shared == false
        error_redirect_to t('notice.not-authorised'), user_index_path
      end
    rescue
      error_redirect_to t('notice.not-found'), user_index_path
    end
  end
end
