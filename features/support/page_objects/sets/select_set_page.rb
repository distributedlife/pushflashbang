module SelectSetPage
  def is_get?
    true
  end

  def url sut
    "/sets/select"
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

  def select_set index
    @session.find_link("set_#{index}_add_term").click
  end
end
