module ShowSetsPage
  def is_get?
    true
  end

  def url sut
    "/sets/"
  end

  def is_current_page?
    @session.has_content?("All Learning Sets").should == true
  end

  def is_on_page hash
    @session.has_content?(hash[:name]).should == true
    @session.has_content?(hash[:description]).should == true
  end

  def is_not_on_page hash
    @session.has_content?(hash[:name]).should == false
    @session.has_content?(hash[:description]).should == false
  end
end
