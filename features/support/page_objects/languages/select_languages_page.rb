module SelectLanguagePage
  def is_get?
    true
  end

  def url sut
    "/languages/select"
  end

  def is_current_page?
    @session.has_content?("Languages we support").should == true
  end

  def select_language language_id
    @session.find_link("language_#{language_id}_select").click
  end
end
