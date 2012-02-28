Given /^a term with (\d+) translations/ do |count|
  ensure_user_exists_and_is_logged_in

  idiom = create_idiom

  count.to_i.times do
    create_translation nil
  end
end

Given /^the following related translations:$/ do |table|
  idiom = create_idiom

  ensure_languages_exist table

  table.hashes.each do |hash|
    create_translation_attached_to_idiom idiom, hash
  end
end

Given /^the following related translations attached to the "([^"]*)" set:$/ do |set_name, table|
  idiom = create_idiom

  ensure_languages_exist table

  table.hashes.each do |hash|
    translation = create_translation_attached_to_idiom idiom, hash
  end

  set = get_set_from_name set_name
  attach_idiom_to_set idiom, set
end

Given /^the following related translations attached to chapter "([^"]*)" the "([^"]*)" set:$/ do |chapter, set_name, table|
  idiom = create_idiom

  ensure_languages_exist table

  table.hashes.each do |hash|
    translation = create_translation_attached_to_idiom idiom, hash
  end

  set = get_set_from_name set_name
  attach_idiom_to_set idiom, set, chapter.to_i
end

Given /^the following related translations attached to chapter "([^"]*)" in position "([^"]*)" of the "([^"]*)" set:$/ do |chapter, position, set_name, table|
  idiom = create_idiom

  ensure_languages_exist table

  table.hashes.each do |hash|
    translation = create_translation_attached_to_idiom idiom, hash
  end

  set = get_set_from_name set_name
  attach_idiom_to_set idiom, set, chapter.to_i, position.to_i
end


################################################################################

When /^I create the following related terms:$/ do |table|
  ensure_user_exists_and_is_logged_in

  ensure_languages_exist table

  goto_page :AddTermPage, Capybara.current_session, sut do |page|
    table.hashes.each_with_index do |hash, i|
      if i >= 2
        page.add_translation_slot
      end

      page.set_translation i, hash
    end

    page.add_translations
  end
end

When /^translations will all linked to the same idiom$/ do
  idiom = Idiom.first

  Translation.all.each do |link|
    link.idiom_id.should == idiom.id
  end

  Translation.count.should_not == 0
  Idiom.count.should_not == 0
end

When /^I view the following translations to the group containing "([^"]*)"$/ do |form|
  idiom = get_idiom_containing_form form

  add(:idiom, idiom)

  goto_page :ShowTermPage, Capybara.current_session, sut
end

When /^I edit the translation "([^"]*)" to "([^"]*)"$/ do |old_value, new_value|
  idiom = get_idiom_containing_form old_value

  add(:idiom, idiom)

  goto_page :EditTermPage, Capybara.current_session, sut do |page|
    page.change_form_from_old_value_to_new old_value, new_value
    page.save_changes
  end
end

When /^I attach the following translations to the group containing "([^"]*)"$/ do |form, table|
  idiom = get_idiom_containing_form form

  add(:idiom, idiom)

  goto_page :EditTermPage, Capybara.current_session, sut do |page|
    table.hashes.each do |hash|
      page.add_translation_slot
      page.set_translation page.get_latest_translation_slot_index, hash
      page.save_changes
    end
  end
end

When /^I view all terms$/ do
  goto_page :ShowTermsPage, Capybara.current_session, sut
end

When /^I delete a translation/ do
  goto_page :EditTermPage, Capybara.current_session, sut do |page|
    page.delete_translation 1
  end
end

When /^I move "([^"]*)" to the group containing "([^"]*)"$/ do |form, target_group_form|
  idiom = get_idiom_containing_form form

  add(:idiom, idiom)
  
  goto_page :EditTermPage, Capybara.current_session, sut do |page|
    page.move_translation(page.get_index_where_form(form))
  end

  idiom_translations = get_translation_group_using_form target_group_form
  on_page :SelectTermPage, Capybara.current_session do |page|
    page.search_for target_group_form
    page.select_term_to_move idiom_translations.first.idiom_id
  end
end

When /^I attach "([^"]*)" to the group containing "([^"]*)"$/ do |form, target_group_form|
  idiom = get_idiom_containing_form form

  add(:idiom, idiom)

  goto_page :EditTermPage, Capybara.current_session, sut do |page|
#    page.attach_translation
    page.move_translation(page.get_index_where_form(form))
  end

  idiom_translations = get_translation_group_using_form target_group_form
#  translation = Translation.where(:form => form).first
  on_page :SelectTermPage, Capybara.current_session do |page|
    page.search_for target_group_form
#    page.select_term translation.idiom_id
#    page.select_translation translation.id
#    page.search_for target_group_form
    page.select_term idiom_translations.first.idiom_id
  end
end

When /^I attach and remove "([^"]*)" to the group containing "([^"]*)"$/ do |form, target_group_form|
  idiom = get_idiom_containing_form target_group_form

  add(:idiom, idiom)

  goto_page :ShowTermPage, Capybara.current_session, sut do |page|
    page.attach_translation
  end

  translation = Translation.where(:form => form).first
  on_page :SelectTranslationPage, Capybara.current_session do |page|
    page.select_and_remove_translation translation.id
  end
end




Then /^the group containing "([^"]*)" should have the following translations:$/ do |form, table|
  idiom_translations = get_translation_group_using_idiom(get_idiom_containing_form form)

  idiom_translations.count.should == table.hashes.count

  idiom_translations.each do |idiom_translation|
    translation_found_in_view = false

    table.hashes.each do |hash|
      if idiom_translation.form == hash[:form]
        translation_found_in_view = true
      end

      break if translation_found_in_view
    end

    translation_found_in_view.should be true
  end
end

Then /^all translations are shown grouped and sorted alphabetically by language:$/ do |table|
  on_page :ShowTermsPage, Capybara.current_session do |page|
    translations = all('#translation')
    index = 0 ;

    table.hashes.each do |hash|
      page.is_on_page hash

      translations[index].find('#form').has_content?(hash[:form])
      translations[index].find('#language').has_content?(hash[:language])
      translations[index].find('#pronunciation').has_content?(hash[:pronunciation]) unless hash[:pronunciation].nil?

      index = index + 1
    end
  end
end

Then /^the term will have (\d+) translations/ do |count|
  Translation.where(:idiom_id => get(:idiom).id).count.should == count.to_i
end

Then /^I should see the following in the form:$/ do |table|
  ensure_user_exists_and_is_logged_in

  on_page :AddTermPage, Capybara.current_session do |page|
    table.hashes.each_with_index do |hash, i|
      page.form_has_hash_contents i, hash
    end
  end
end