module ReviewTermPage
  def is_get?
    true
  end

  def url sut
    "/languages/#{sut.get(:language).id}/sets/#{sut.get(:set).id}/terms/#{sut.get(:idiom).id}/review?review_mode=#{sut.get(:review_mode)}"
  end

  def is_current_page?
    @session.has_content? "Review"
  end

  def is_term term_id
    @session.find("#term_#{term_id}")
  end

  def text_input_is_visible?
    div_is_visible '#answer_form'
  end

  def text_input_is_hidden?
    div_is_hidden '#answer_form'
  end

  def is_audio_visible?
#    div_is_visible 'audio'
    true
  end

  def is_audio_hidden?
    div_is_hidden 'audio'
  end

  def reveal!
    if div_is_hidden("#back_of_card")
      @session.click_on("Reveal")
    end
  end

  def native_language_is_hidden?
    div_is_hidden 'native_form'
  end

  def learned_language_is_hidden?
    div_is_hidden 'learned_form'
  end
  
  def native_language_contains? form
    does_one_element_of_set_contain '.native_form', form
  end

  def learned_language_contains? form
    does_one_element_of_set_contain '.learned_form', form
  end

  private
  def does_one_element_of_set_contain element, set
    found = false

    @session.all(element).each do |native_form|
      if native_form.text[set]
        found = true
      end
    end

    found
  end

  def div_is_visible div_name
    begin
      @session.find(div_name)
    rescue
      return false
    end

    return true
  end

  def div_is_hidden div_name
    begin
      @session.find(div_name)
    rescue
      return true
    end

    return false
  end
end
