module SiteIndexPage
  def is_get?
    true
  end
  
  def url sut
    "/"
  end

  def is_current_page?
    @session.has_content?("PushFlashBang").should == true
    @session.has_content?("Language learning tools").should == true
  end
end
