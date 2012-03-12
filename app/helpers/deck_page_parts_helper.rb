# -*- encoding : utf-8 -*-
module DeckPagePartsHelper
  def new_deck_link
    link_to "New Deck", new_deck_path, :method => :post, :class => 'contrast', :id => "add_deck"
  end
  
  def list_decks decks
    render :partial => '/deck/user_decks', :locals => {:decks => decks}
  end

  def deck_home_link deck_id
    link_to('Deck', deck_path(deck_id), :id => "deck_#{deck_id}")
  end

  def show_card_front_large card
    render :partial => '/card/show_card_front_large', :locals => {:card => card}
  end

  def show_card_front card
    render :partial => '/card/show_card_front', :locals => {:card => card}
  end

  def show_card_audio card
    return unless card.audio.file?
    
    render :partial => '/audio_controls', :locals => {:audio_url => card.audio.url}
  end

  def show_card_back_large card
    return if card.back.blank?
    
    render :partial => '/card/show_card_back_large', :locals => {:card => card}
  end

  def show_card_pronunciation_large card
    return if card.pronunciation.blank?

    render :partial => '/card/show_card_pronunciation_large', :locals => {:card => card}
  end

  def edit_card_link deck_id, card_id
    link_to content_tag('i', '', :class => 'icon-edit'), edit_deck_card_path(deck_id, card_id), :id => "edit_deck#{deck_id}_card#{card_id}"
  end

  def card_reveal_button
    link_to t('actions.reveal'), '#', :class => 'btn btn-large btn-primary', :id => "do_reveal"
  end

  def card_review_didnt_know card
    render :partial => '/card/card_review_didnt_know', :locals => {:card => card}
  end

  def card_review_shaky_good card
    render :partial => '/card/card_review_shaky_good', :locals => {:card => card}
  end

  def card_review_partial_answer card
    render :partial => '/card/card_review_partial_answer', :locals => {:card => card}
  end

  def card_review_confident card
    render :partial => '/card/card_review_confident', :locals => {:card => card}
  end

  def show_card_pronunciation_on_front card, pronunciation_side
    return unless is_pronunciation_on_front? pronunciation_side
    return if card.pronunciation.empty?

    render :partial => '/card/display_card_pronunciation', :locals => {:card => card}
  end

  def show_card_pronunciation_on_back card, pronunciation_side
    return unless is_pronunciation_on_back? pronunciation_side
    return if card.pronunciation.empty?

    render :partial => '/card/display_card_pronunciation', :locals => {:card => card}
  end

  def show_back_of_card card, pronunciation_side, hidden = true
    return if card.back.blank?

    render :partial => '/card/display_back_of_card', :locals => {:card => card, :pronunciation_side => pronunciation_side, :hidden => hidden ? "hidden" : "not-hidden"}
  end

  def chapter_advance_button deck_id
    link_to t('actions.advance'), advance_deck_chapter_path(deck_id), :class => 'btn btn-large btn-primary', :id => 'do_advance'
  end

  def card_cram_next_button deck, card
    link_to t('actions.next'), cram_deck_chapter_path(:deck_id => deck.id, :id => card.chapter, :card_id => card.id), :id => "do_next", :class => 'btn btn-large btn-primary'
  end
end
