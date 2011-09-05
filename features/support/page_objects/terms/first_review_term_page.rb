module FirstReviewTermPage
  def is_get?
    true
  end

  def url sut
    "/languages/#{sut.get(:language).id}/sets/#{sut.get(:set).id}/terms/#{sut.get(:idiom).id}/first_review?review_mode=#{sut.get(:review_mode)}"
  end

  def is_current_page?
    @session.has_content? "New Term"
  end

  def is_term term_id
    @session.find("#term_#{term_id}")
  end
  
  def native_language_contains? form
    does_one_element_of_set_contain '.native_form', form
  end

  def learned_language_contains? form
    does_one_element_of_set_contain '.learned_form', form
  end

  def button_exists? button_name
    @session.find_link(button_name).nil?.should == false
  end

  def do_record_review
    @session.click_on "do_results"
  end

  def meaning_count_is? count
    @session.find("p#meaning_count").text == count
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
