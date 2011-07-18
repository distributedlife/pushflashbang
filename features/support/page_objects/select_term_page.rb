module SelectTermPage
  def is_get?
    false
  end

  def url sut
    "/terms/select/?idiom_id=#{sut.get(:idiom).id}&translation_id=#{sut.get(:translation).id}"
  end

  def is_current_page?
    @session.has_content?("Select a term").should == true
  end

  def select_term idiom_id
    @session.find_link("translation_#{idiom_id}_select").click
  end

  def get_index_where_form form
    i = 0

    while true do
      if @session.find("#translation_#{i}").nil?
        raise "the form could not be found in the FORM field on this page"
      end

      translation = @session.find("#translation_#{i}")
      if translation.has_content?(form)
        return i
      end

      i = i + 1
    end
  end
end
