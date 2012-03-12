# -*- encoding : utf-8 -*-
module UserLanguagesPage
  def is_get?
    true
  end

  def url sut
    "/users/languages/"
  end

  def is_current_page?
    @session.has_content?("Languages").should == true
  end

  def learn_language language
    @session.find_link("language_#{language.id}_start_learning").click
  end

  def stop_learning_language language
    @session.find_link("language_#{language.id}_stop_learning").click
  end
end
