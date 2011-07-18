module EditSetPage
  def is_get?
    true
  end

  def url sut
    "/sets/#{sut.get(:set).id}/edit"
  end

  def is_current_page?
    @session.has_content?("Edit set").should == true
  end

  def fill_in index, hash
    @session.fill_in("set_name_#{index}_name", :with => hash[:name])
    @session.fill_in("set_name_#{index}_description", :with => hash[:description])
  end

  def add_name_slot
    @session.click_on("Add set name translation")
  end

  def save_changes
    @session.click_on("Save")
  end

  def get_latest_slot_index
    i = 0

    while true do
      return i if @session.find_field("set_name_#{i}_form").nil?

      i = i + 1
    end

    i
  end
end
