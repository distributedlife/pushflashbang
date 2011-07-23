module ShowLanguagePage
  def is_get?
    true
  end

  def url sut
    "/languages/#{sut.get(:language).id}"
  end

  def is_current_page?
    @session.has_content?("Languages").should == true
  end

  def is_set_on_page hash
    
  end
end
