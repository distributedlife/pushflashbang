# -*- encoding : utf-8 -*-
module SetComponent
  def create_set hash
    verify_set_prerequisites

    set = Sets.make!
    set_name = SetName.new hash
    set_name.sets_id = set.id
    set_name.save

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

  def add_set_name hash
    verify_set_prerequisites
    verify_set_name_prerequisites

    set_name = SetName.new hash
    set_name.sets_id = get(:set).id
    set_name.save

    add(:set_name, set_name)
  end

  def user_add_set_name hash
    goto_page :EditSetPage, Capybara.current_session, sut do |page|
      page.add_name_slot
      page.fill_in hash, page.get_latest_slot_index

      add(:set_name, SetName.last)
    end
  end

  def get_set_from_name name
    set_name = SetName.where(:name => name)

    return Sets.find(set_name.first.sets_id)
  end

  def get_set_name name
    get_first SetName.where(:name => name)
  end

  def attach_idiom_to_set idiom, set, chapter = 1, position = 1
    add(:set_term, SetTerms.make!(:set_id => set.id, :term_id => idiom.id, :chapter => chapter, :position => position))
  end

  private
  def verify_set_prerequisites
    ensure_user_exists_and_is_logged_in
  end

  def verify_set_name_prerequisites
    if does_not_exist(:set)
      add(:set, Sets.make!)
    end
  end
end
