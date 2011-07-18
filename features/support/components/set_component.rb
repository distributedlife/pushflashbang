module SetComponent
  def create_set hash
    verify_set_prerequisites

    set = Sets.create
    set_name = SetName.new hash
    set_name.sets_id = set.id

    add(:set, set)
    add(:set_name, set_name)
  end

  def user_create_set hash
    verify_set_prerequisites
    
    goto_page :NewSetPage, Capybara.current_session, sut do |page|
      page.fill_in hash
      page.create

      add(:set, Sets.last)
    end
  end

  def user_add_set_name hash
    goto_page :EditSetPage, Capybara.current_session, sut do |page|
      page.add_name_slot
      page.fill_in hash page.get_latest_slot_index

      add(:set_name, SetName.last)
    end
  end

  private
  def verify_set_prerequisites
    ensure_user_exists_and_is_logged_in
  end
end