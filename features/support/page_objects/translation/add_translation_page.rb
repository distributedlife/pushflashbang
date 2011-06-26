module AddTranslatiosPage
  def is_get?
    true
  end

  def url sut
    "/terms/"
  end

  def is_current_page?
    @session.has_content?("Create New Translation").should == true
  end

  def create_translation hash
    @session.fill_in('translation_form', hash[:form])
    @session.fill_in('translation_language', hash[:language])
    @session.fill_in('translation_pronunciation', hash[:pronunciation])
  end
end
