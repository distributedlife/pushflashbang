module SelectTranslationPage
  def is_get?
    false
  end

  def url sut
    "/terms/#{sut.get(:idiom).id}/translations"
  end

  def is_current_page?
    @session.has_content?("Select translations to attach").should == true
  end

  def select_translation translation_id
    @session.find_link("translation_#{translation_id}_select").click
  end

  def select_and_remove_translation translation_id
    @session.find_link("translation_#{translation_id}_select_and_remove").click
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
