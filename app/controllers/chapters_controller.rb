class ChaptersController < ApplicationController
  before_filter :authenticate_user!

  def show
    begin
      if deck_is_valid?
        cards = Card.where(:deck_id => params[:deck_id])
        if cards.empty?
          flash[:failure] = "You can't start a session until you have added cards to the deck."
          redirect_to deck_path(params[:deck_id])
          return
        end

        if UserCardSchedule::get_due_count_for_user_for_deck(current_user.id, params[:deck_id]) > 0
          redirect_to learn_deck_path(params[:deck_id])
        else
          @deck = Deck.find(params[:deck_id])
          @upcoming_cards = ActiveRecord::Base.connection.execute("SELECT cards.id, cards.front, cards.back, cards.pronunciation, user_card_schedules.due FROM cards, user_card_schedules where deck_id = #{params[:deck_id]} and cards.id = user_card_schedules.card_id and user_id = #{current_user.id} order by due asc")
        end
      end
    rescue
    end
  end

  def advance
    begin
      if deck_is_valid?
        user_deck_chapter = UserDeckChapter.where(:user_id => current_user.id, :deck_id => params[:deck_id]).first

        max_chapter = Card.where(:deck_id => params[:deck_id]).maximum(:chapter)

        #get me a greater chapter from the deck that exists, but only consider cards that have not been scheduled
        next_chapter = Card.where(["deck_id = ? and chapter > ? and id not in (select card_id from user_card_schedules where user_id = ?)", params[:deck_id], user_deck_chapter.chapter, current_user.id]).minimum("chapter")

        user_deck_chapter.chapter = next_chapter unless user_deck_chapter.chapter >= max_chapter
        user_deck_chapter.save

        redirect_to learn_deck_path(params[:deck_id])
      end
    rescue
      redirect_to learn_deck_path(params[:deck_id])
    end
  end

  def reveal
    begin
      if deck_is_valid?
        @deck = Deck.find(params[:deck_id])
        @cards = Card.order(:created_at).where(:deck_id => params[:deck_id], :chapter => params[:id])
      end

    rescue
      redirect_to(user_index_path)
    end
  end

  def cram
    begin
      if deck_is_valid?
        if Card.where(:deck_id => params[:deck_id], :chapter => params[:id]).count == 0 
          flash[:failure] = "You can't cram until you have added cards to the chapter."
          redirect_to deck_path(params[:deck_id])
          return
        end

        last_card = params[:card_id]
        last_card ||= 0

        #get next card in chapter
        chapter_card = Card.order(:created_at).where(['deck_id = ? and chapter = ? and id > ?', params[:deck_id], params[:id], last_card]).first
        if chapter_card.nil?
          #finished cramming; return to deck_home
          redirect_to deck_path(params[:deck_id])
        else
          redirect_to cram_deck_card_path(params[:deck_id], chapter_card.id)
        end
      end
    rescue
      redirect_to(user_index_path)
    end
  end

  private
  def deck_is_valid?
    begin
      deck = Deck.find(params[:deck_id])

      if deck.user != current_user && deck.shared == false
        flash[:failure] = "Unable to show deck as it does not belong to you and it has not been shared"
        redirect_to(user_index_path)

        return false
      end

      true
    rescue
      flash[:failure] = "The deck no longer exists"
      redirect_to(user_index_path)
      return false
    end
  end
end
