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
    element_is_visible '#answer'
  end

  def text_input_is_hidden?
    element_is_hidden '#answer'
  end

  def is_audio_visible?
#    element_is_visible 'audio'
    true
  end

  def is_audio_hidden?
    element_is_hidden 'audio'
  end

  def reveal!
    if element_is_hidden("#back_of_card")
      @session.click_on("Reveal")
    end
  end

  def native_language_is_hidden?
    element_is_hidden 'native_form'
  end

  def learned_language_is_hidden?
    element_is_hidden 'learned_form'
  end
  
  def native_language_contains? form
    does_one_element_of_set_contain '.native_form', form
  end

  def learned_language_contains? form
    does_one_element_of_set_contain '.learned_form', form
  end

  def set_text_answer answer
    @session.fill_in("answer_form", :with => answer)
  end

  def is_answer_correct?
    @session.has_content? "is correct"
  end

  def is_answer_incorrect?
    @session.has_content? "is not correct"
  end

  def answer_control_is_set_as? review_type, value
    element_is_visible("#review_result_#{review_type}").should == true

    @session.find_field("review_result_#{review_type}")[:checked].should == value.to_s
  end

  def button_exists? button_name
    @session.find_link(button_name).nil?.should == false
  end

  def set_check_box review_type, state
    if state == "checked"
      @session.check("review_result_#{review_type}")
    else
      @session.uncheck("review_result_#{review_type}")
    end
  end

  def do_record_review
    @session.click_on "do_results"
  end

  def do_record_review_perfect
    @session.click_on "do_result_perfect"
  end

  def meaning_count_is? count
    @session.find("#meaning_count").text == count
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

  def element_is_visible div_name
    begin
      @session.find(div_name)
    rescue
      return false
    end

    return true
  end

  def element_is_hidden div_name
    begin
      @session.find(div_name)
    rescue
      return true
    end

    return false
  end
end
