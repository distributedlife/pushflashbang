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

  def is_user_set hash
    sets = @session.find("#user_sets")

    set_name = SetName.where(:name => hash[:name]).first
    sets.find("#set_#{set_name.sets_id}_name").text.should == set_name.name
  end

  def is_available_set hash
    sets = @session.find("#available_sets")

    set_name = SetName.where(:name => hash[:name]).first
    sets.find("#set_#{set_name.sets_id}_name").text.should == set_name.name
  end
end
