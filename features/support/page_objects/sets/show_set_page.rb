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

  def is_set_on_page hash
    @session.has_content?(hash[:name]).should == true
    @session.has_content?(hash[:description]).should == true
  end

  def is_term_on_page hash
    @session.has_content?(hash[:form]).should == true
    @session.has_content?(hash[:language]).should == true
    @session.has_content?(hash[:pronunciation]).should == true
  end

  def is_term_not_on_page hash
    @session.has_content?(hash[:form]).should == false
    @session.has_content?(hash[:language]).should == false
    @session.has_content?(hash[:pronunciation]).should == false unless hash[:pronunciation].empty?
  end

  def language_support_on_page hash
    @session.has_content?(hash[:language]).should == true
    @session.has_content?(hash[:count]).should == true
  end

  def remove_term id
    @session.find_link("term_#{id}_remove_from_set").click
  end

  def add_term set_id
    @session.find_link("add_term_to_set_#{set_id}").click
#    @session.find_link("add_term").click
  end

  def move_term_next_chapter id
    @session.find_link("term_#{id}_next_chapter").click
  end

  def move_term_prev_chapter id
    @session.find_link("term_#{id}_prev_chapter").click
  end

  def move_term_next_position id
    @session.find_link("term_#{id}_next_position").click
  end

  def move_term_prev_position id
    @session.find_link("term_#{id}_prev_position").click
  end

  def set_as_goal set_id, language_id
    @session.find_link("set_#{set_id}_for_#{language_id}_goal").click
  end

  def unset_as_goal
    @session.find_link("unset_goal").click
  end

  def expand_chapter chapter
    @session.find_link("toggle_chapter_#{chapter}").click
  end
end