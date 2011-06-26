module ShowTranslationsPage
  def is_get?
    true
  end

  def url sut
    "/terms/"
  end

  def is_current_page?
    @session.has_content?("Terms").should == true
  end

  def is_on_page translation_hash
    @session.has_content?(translation_hash[:form]).should == true
    @session.has_content?(translation_hash[:language]).should == true
    @session.has_content?(translation_hash[:pronunciation]).should == true unless translation_hash[:pronunciation].nil?
  end
end
