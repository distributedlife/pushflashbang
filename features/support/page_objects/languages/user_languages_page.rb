module UserLanguagesPage
  def is_get?
    true
  end

  def url sut
    "/languages/user"
  end

  def is_current_page?
    @session.has_content?("Languages").should == true
  end

  def learn_language language
    @session.find("#language_#{language.id}").click_link('start learning?')
  end

  def stop_learning_language language
    @session.find("#language_#{language.id}").click_link('stop learning?')
  end
end
