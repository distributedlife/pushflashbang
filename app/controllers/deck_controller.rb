# -*- encoding : utf-8 -*-
include DeckHelper
include RedirectHelper

class DeckController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    @deck = Deck.new(params[:deck])
    @deck.user = current_user
    @deck.pronunciation_side ||= 'front'

    @pronunciation_side_values = Deck::SIDES

    if @deck.valid?
      @deck.save!

      success_redirect_to t('notice.deck-create'), show_deck_path(@deck)
    end
  end

  def edit
    begin
      if deck_is_valid?
        @deck = Deck.find(params[:id])
        @pronunciation_side_values = Deck::SIDES
      end
    rescue
    end
  end

  def update
    begin
      if deck_is_valid?

        deck = Deck.find(params[:id])
        deck.update_attributes(params[:deck])

        if deck.invalid?
          @deck = deck
        else
          deck.save!
          success_redirect_to t('notice.deck-update'), show_deck_path(@deck)
        end
      end
    rescue
    end
  end

  def index
    @decks = Deck.order(:name).where("user_id = :user_id OR shared = :shared", :user_id => current_user.id, :shared => true)
  end

  def show
    begin
      if deck_is_valid?
        @deck = Deck.find(params[:id])
        @chapters = @deck.get_chapters
      end
    rescue
    end
  end

  def destroy
    begin
      if deck_is_valid?

        deck = Deck.find(params[:id])

        if deck.user == current_user
          deck.delete

          success_redirect_to t('notice.deck-delete'), user_index_path
        else
          error_redirect_to t('notice.not-authorised'), user_index_path
        end
      end
    rescue
      success_redirect_to t('notice.deck-delete'), user_index_path
    end
  end

  def upcoming
    begin
      if deck_is_valid?
        cards = Card.where(:deck_id => params[:id])
        if cards.empty?
          error_redirect_to t('notice.deck-no-cards'), deck_path(params[:id])
          return
        end

        if UserCardSchedule::get_due_count_for_user_for_deck(current_user.id, params[:id]) > 0
          redirect_to learn_deck_path(params[:id])
        else
          @deck = Deck.find(params[:id])
          @upcoming_cards = ActiveRecord::Base.connection.execute("SELECT cards.id, cards.front, cards.back, cards.pronunciation, user_card_schedules.due FROM cards, user_card_schedules where deck_id = #{params[:id]} and cards.id = user_card_schedules.card_id and user_id = #{current_user.id} order by due asc")
        end
      end
    rescue
    end
  end

  def learn
    begin
      if deck_is_valid?
        #if there are no cards in deck; we should not try and schedule any
        if Card.where(:deck_id => params[:id]).count == 0
          error_redirect_to t('notice.deck-no-cards'), deck_path(params[:id])
          return
        end

        #get user deck chapter
        deck_chapter = UserDeckChapter.where(:deck_id => params[:id], :user_id => current_user.id)
        if deck_chapter.empty?
          deck_chapter = UserDeckChapter.create(:deck_id => params[:id], :user_id => current_user.id, :chapter => 1)
        else
          deck_chapter = deck_chapter.first
        end


        #get next scheduled card for user
        scheduled_card = UserCardSchedule::get_next_due_for_user_for_deck(current_user.id, params[:id])
        unless scheduled_card.nil?
          redirect_to learn_deck_card_path(params[:id], scheduled_card.card_id)
          return
        end


        #if there are no scheduled cards for the user; get the first card in the deck that has not been scheduled and schedule it
        next_card = Card::get_first_unscheduled_card_for_deck_for_user(current_user.id, params[:id])
        if next_card.nil?
          redirect_to upcoming_deck_path(params[:id])
          return
        end


        if next_card.chapter > deck_chapter.chapter
          redirect_to deck_chapter_path(params[:id], next_card.chapter)
        else
          scheduled_card = UserCardSchedule.create(:user_id => current_user.id, :due => Time.now, :interval => 0, :card_id => next_card.id)
          redirect_to learn_deck_card_path(params[:id], scheduled_card.card_id)
        end
      end
    rescue
    end
  end

  def toggle_share
    if deck_is_valid?
      deck = Deck.find(params[:id])

      if deck.user == current_user
        deck.shared = !deck.shared
        deck.save!

        if deck.shared
          info_redirect_to t('notice.deck-shared'), deck_path(params[:id])
        else
          info_redirect_to t('notice.deck-private'), deck_path(params[:id])
        end
      else
        error_redirect_to t('notice.not-authorised'), deck_path(params[:id])
      end
    end
  end

  def due_count
    @due_count = UserCardSchedule.get_due_count_for_user_for_deck(current_user.id, params[:id])

    respond_to do |format|
      format.json { render :json => @due_count}
    end
  end

  private
  def deck_is_valid?
    begin
      deck = Deck.find(params[:id])

      if deck.user != current_user && deck.shared == false
        error_redirect_to t('notice.not-authorised'), user_index_path

        return false
      end

      true
    rescue
      error_redirect_to t('notice.not-found'), user_index_path
      return false
    end
  end
end
