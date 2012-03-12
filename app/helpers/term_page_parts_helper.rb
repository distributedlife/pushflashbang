# -*- encoding : utf-8 -*-
module TermPagePartsHelper
  def ok_first_review_button
    link_to t('actions.ok'), '#', :class => 'btn btn-large btn-primary', :method => :post, :id => "do_results"
  end

  def display_pronunciation_guidance idioms, language, hidden = false
    render :partial => '/terms/display_pronunciation_guidance', :locals => {:idioms => idioms, :language => language, :hidden => hidden}
  end

  def display_reveal_button
    render :partial => '/terms/display_reveal_button'
  end

  def reveal_button
    link_to t('actions.reveal'), '#', :class => 'btn btn-primary btn-large', :id => "do_reveal"
  end

  def display_review_buttons review_mode, review_text, is_new = false
    if is_new
      render :partial => '/terms/display_review_button_first_sight', :locals => {:review_mode => review_mode}
    else
      render :partial => '/terms/display_review_buttons', :locals => {:review_mode => review_mode, :review_text => review_text}
    end
  end

  def display_term_to_review term, native, learned, audio, typed, learned_translations_in_idiom, native_translations, idioms, learned_language, native_language, is_new = false
    render :partial => '/terms/display_term_to_review', :locals => {:term => term, :native => native, :learned => learned, :audio => audio, :typed => typed, :new => is_new, :learned_translations_in_idiom => learned_translations_in_idiom, :native_translations => native_translations, :idioms => idioms, :learned_language => learned_language, :native_language => native_language}
  end

  def display_review_content native_translations, learned_translations, native, learned, audio, typed, is_new
    return if is_new

    render :partial => '/terms/display_review_content', :locals => {:native_translations => native_translations, :learned_translations => learned_translations, :native => native, :learned => learned, :audio => audio, :typed => typed}
  end

  def record_answer_button review_mode
    render :partial => '/terms/record_answer_button', :locals => {:review_mode => review_mode}
  end

  def record_perfect_answer_button review_mode
    render :partial => '/terms/record_perfect_answer_button', :locals => {:review_mode => review_mode}
  end

  def record_review_buttons review_mode, review_text, form
    render :partial => '/terms/record_review_buttons', :locals => {:review_mode => review_mode, :review_text => review_text, :f => form}
  end

  def back_of_card idioms, learned_language, native_language, new
    render :partial => '/terms/back_of_card', :locals => {:idioms => idioms, :learned_language => learned_language, :native_language => native_language, :new => new}
  end

  def advance_button language_id, set_id, review_mode
    link_to t('actions.advance'), advance_chapter_language_set_path(language_id, set_id, :review_mode => review_mode), :class => 'btn btn-large btn-primary', :id => 'do_advance', :method => :post
  end
end
