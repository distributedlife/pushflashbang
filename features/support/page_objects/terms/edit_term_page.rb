module EditTermPage
  def is_get?
    true
  end

  def url sut
    "/terms/#{sut.get(:idiom).id}/edit"
  end

  def is_current_page?
    @session.has_content?("Edit a set of related translations").should == true
  end

  def set_translation index, hash
    @session.fill_in("translation_#{index}_form", :with => hash[:form])
    @session.fill_in("translation_#{index}_language", :with => hash[:language])
    @session.fill_in("translation_#{index}_pronunciation", :with => hash[:pronunciation])
  end

  def form_has_hash_contents index, hash
    @session.find_field("translation_#{index}_form").value.should == hash[:form]
    @session.find_field("translation_#{index}_language").value.should == hash[:language]
    @session.find_field("translation_#{index}_pronunciation").value.should == hash[:pronunciation]
  end

  def add_translation_slot
    @session.click_on("Add a new translation")
  end

  def save_changes
    @session.click_on("Save Changes")
  end

  def delete_translation index
    @session.find_link("translation_#{index}_delete").click
  end

  def move_translation index
    @session.find_link("translation_#{index}_move").click
  end

  def attach_translation index
    @session.find_link("translation_#{index}_attach").click
  end

  def change_form_from_old_value_to_new old_value, new_value
    changed = false
    i = 0

    while not changed do
      if @session.find_field("translation_#{i}_form").nil?
        raise "the old value could not be found in the FORM field on this page"
      end

      if @session.find_field("translation_#{i}_form").value == old_value
        @session.fill_in("translation_#{i}_form", :with => new_value)
        changed = true
      end

      i = i + 1
    end
  end

  def get_index_where_form form
    i = 0

    while true do
      if @session.find_field("translation_#{i}_form").nil?
        raise "the form could not be found in the FORM field on this page"
      end

      if @session.find_field("translation_#{i}_form").value == form
        return i
      end

      i = i + 1
    end
  end

  def get_latest_translation_slot_index
    i = 0

    while true do
      return i if @session.find_field("translation_#{i}_form").nil?

      i = i + 1
    end

    i
  end
end
