module ShowSetPage
  def is_get?
    true
  end

  def url sut
    "/sets/#{sut.get(:set).id}"
  end

  def is_current_page?
    @session.has_content?("Set").should == true
  end

  def is_on_page hash
    @session.has_content?(hash[:name]).should == true
    @session.has_content?(hash[:description]).should == true
  end
end
