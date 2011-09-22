################################################################################
# Data Setup
################################################################################
Given /^the following sets:$/ do |table|
  table.hashes.each do |hash|
    create_set(hash)
  end
end

Given /^a set with the following names:$/ do |table|
  table.hashes.each_with_index do |hash, i|
     if i == 0
       create_set hash
     else
      add_set_name hash
     end
  end
end

Given /^I am on viewing the set "([^"]*)"$/ do |set_name|
  add(:set, get_set_from_name(set_name))
  
  goto_page :ShowSetPage, Capybara.current_session, sut
end

Given /^the group containing "([^"]*)" is in the set "([^"]*)"$/ do |containing_form, set_name|
  set = get_set_from_name set_name
  idiom = get_idiom_containing_form containing_form

  SetTerms.create(:set_id => set.id, :term_id => idiom.id, :chapter => 1, :position => 1)
end

Given /^the group containing "([^"]*)" is in the set "([^"]*)" in chapter "([^"]*)"$/ do |containing_form, set_name, chapter|
  set = get_set_from_name set_name
  idiom = get_idiom_containing_form containing_form

  SetTerms.create(:set_id => set.id, :term_id => idiom.id, :chapter => chapter.to_i, :position => 1)
end

Given /^the user has the "([^"]*)" set as a goal for the "([^"]*)" language$/ do |set_name, language_name|
  add(:set, get_set_from_name(set_name))
  add(:language, get_language(language_name))

  UserSets.create(:user_id => get(:user).id, :set_id => get(:set).id, :language_id => get(:language).id, :chapter => 1)
  UserLanguages.create(:user_id => get(:user).id, :language_id => get(:language).id) if UserLanguages.where(:user_id => get(:user).id, :language_id => get(:language).id).empty?
end


################################################################################
# AS USER
################################################################################
When /^I create the following sets:$/ do |table|
  table.hashes.each do |hash|
    user_create_set hash
  end
end

When /^I create a set with the following:$/ do |table|
  table.hashes.each_with_index do |hash, i|
     if i == 0
       user_create_set hash
     else
      user_add_set_name hash
     end
  end
end

When /^I edit the set called "([^"]*)" to:$/ do |set_name, table|
  add(:set, get_set_from_name(set_name))
  
  goto_page :EditSetPage, Capybara.current_session, sut do |page|
    table.hashes.each do |hash|
      page.fill_in page.get_index_where_set_name(set_name), hash
    end
    page.save_changes
  end
end

When /^I delete the set name "([^"]*)"$/ do |set_name|
  add(:set, get_set_from_name(set_name))

  goto_page :EditSetPage, Capybara.current_session, sut do |page|
    page.delete_set_name page.get_index_where_set_name set_name
  end
end

When /^I delete the set called "([^"]*)"$/ do |set_name|
  add(:set, get_set_from_name(set_name))

  goto_page :EditSetPage, Capybara.current_session, sut do |page|
    page.delete_set
  end
end

When /^I add the group containing "([^"]*)" to the set "([^"]*)"$/ do |term_translation, set_name|
  set = get_set_from_name set_name
  idiom = get_idiom_containing_form term_translation

  goto_page :ShowTermsPage, Capybara.current_session, sut do |page|
    page.search_for "a little bit"
    page.add_to_set idiom.id
  end

  on_page :SelectSetPage, Capybara.current_session do |page|
    page.select_set set.id
  end
end

When /^I add the group containing "([^"]*)" to the current set$/ do |containing_form|
  idiom = get_idiom_containing_form containing_form

  on_page :ShowSetPage, Capybara.current_session do |page|
    page.add_term
  end

  on_page :SelectTermForSetPage, Capybara.current_session do |page|
    page.select_term idiom.id
  end
end


When /^I remove the group containing "([^"]*)" to the set "([^"]*)"$/ do |containing_form, set_name|
  add(:set, get_set_from_name(set_name))
  idiom = get_idiom_containing_form containing_form

  get(:user).start_editing

  goto_page :ShowSetPage, Capybara.current_session, sut do |page|
    page.expand_chapter 1
    sleep 0.25
    page.remove_term idiom.id
  end

  get(:user).stop_editing
end

When /^I move the term containing "([^"]*)" to the next chapter in the "([^"]*)" set$/ do |containing_form, set_name|
  add(:set, get_set_from_name(set_name))
  idiom = get_idiom_containing_form containing_form

  get(:user).start_editing

  goto_page :ShowSetPage, Capybara.current_session, sut do |page|
    page.expand_chapter 1
    sleep 0.25

    page.move_term_next_chapter idiom.id
  end

  get(:user).stop_editing
end

When /^I move the term containing "([^"]*)" to the prev chapter in the "([^"]*)" set$/ do |containing_form, set_name|
  add(:set, get_set_from_name(set_name))
  idiom = get_idiom_containing_form containing_form

  get(:user).start_editing

  goto_page :ShowSetPage, Capybara.current_session, sut do |page|
    page.expand_chapter 1
    page.expand_chapter 2
    sleep 0.25

    page.move_term_prev_chapter idiom.id
  end

  get(:user).stop_editing
end

When /^I move the term containing "([^"]*)" down a chapter in the "([^"]*)" set$/ do |containing_form, set_name|
  add(:set, get_set_from_name(set_name))
  idiom = get_idiom_containing_form containing_form

  get(:user).start_editing

  goto_page :ShowSetPage, Capybara.current_session, sut do |page|
    page.expand_chapter 1
    sleep 0.25

    page.move_term_next_position idiom.id
  end

  get(:user).stop_editing
end

When /^I move the term containing "([^"]*)" up a position in the "([^"]*)" set$/ do |containing_form, set_name|
  add(:set, get_set_from_name(set_name))
  idiom = get_idiom_containing_form containing_form

  get(:user).start_editing

  goto_page :ShowSetPage, Capybara.current_session, sut do |page|
    page.expand_chapter 1
    sleep 0.25
    
    page.move_term_prev_position idiom.id
  end

  get(:user).stop_editing
end

When /^I choose the set "([^"]*)" for the "([^"]*)" language as a goal$/ do |set_name, language|
  add(:set, get_set_from_name(set_name))
  language = get_language language

  goto_page :ShowSetPage, Capybara.current_session, sut do |page|
    page.set_as_goal
  end

  on_page :SelectLanguagePage, Capybara.current_session do |page|
    page.select_language language.id
  end
end

When /^I choose to unset "([^"]*)" for the "([^"]*)" language as a goal$/ do |set_name, language|
  add(:set, get_set_from_name(set_name))

  goto_page :ShowSetPage, Capybara.current_session, sut do |page|
    page.unset_as_goal
  end
end



Then /^the following will be visible on the show sets page$/ do |table|
  goto_page :ShowSetsPage, Capybara.current_session, sut do |page|
    table.hashes.each do |hash|
      page.is_on_page hash
    end
  end
end

Then /^the following will not be visible on the show sets page$/ do |table|
  goto_page :ShowSetsPage, Capybara.current_session, sut do |page|
    table.hashes.each do |hash|
      page.is_not_on_page hash
    end
  end
end

Then /^the following will be visible on the show set page$/ do |table|
  goto_page :ShowSetPage, Capybara.current_session, sut do |page|
    table.hashes.each do |hash|
      page.is_term_on_page hash
    end
  end
end

Then /^the following will be not visible on the show set page$/ do |table|
  goto_page :ShowSetPage, Capybara.current_session, sut do |page|
    table.hashes.each do |hash|
      page.is_term_not_on_page hash
    end
  end
end

Then /^I should see the following language support information:$/ do |table|
  on_page :ShowSetPage, Capybara.current_session do |page|
    table.hashes.each do |hash|
      page.language_support_on_page hash
    end
  end
end

Then /^the term containing "([^"]*)" set should be in chapter "([^"]*)" of the "([^"]*)" set$/ do |containing_form, chapter, set_name|
  set = get_set_from_name set_name
  idiom = get_idiom_containing_form containing_form

  sleep 0.25

  SetTerms.where(:set_id => set.id, :term_id => idiom.id, :chapter => chapter.to_i).count.should == 1
end

Then /^the term containing "([^"]*)" set should be in position "([^"]*)" of the "([^"]*)" set$/ do |containing_form, position, set_name|
  set = get_set_from_name set_name
  idiom = get_idiom_containing_form containing_form

  sleep 0.25

  SetTerms.where(:set_id => set.id, :term_id => idiom.id, :position => position.to_i).count.should == 1
end

Then /^the following sets are listed as user goals on the "([^"]*)" language page:$/ do |language_name, table|
  add(:language, get_language(language_name))

  goto_page :ShowLanguagePage, Capybara.current_session, sut do |page|
    table.hashes.each do |hash|
      page.is_user_set hash
    end
  end
end

Then /^the following sets are listed as potential goals on the "([^"]*)" language page:$/ do |language_name, table|
  add(:language, get_language(language_name))

  goto_page :ShowLanguagePage, Capybara.current_session, sut do |page|
    table.hashes.each do |hash|
      page.is_available_set hash
    end
  end
end

Then /^the term containing "([^"]*)" will be in the "([^"]*)" set$/ do |containing_form, set_name|
  set = get_set_from_name set_name
  idiom = get_idiom_containing_form containing_form

  sleep 0.25
  
  SetTerms.where(:set_id => set.id, :term_id => idiom.id).count.should == 1
end

Then /^the term containing "([^"]*)" will not be in the "([^"]*)" set$/ do |containing_form, set_name|
  set = get_set_from_name set_name
  idiom = get_idiom_containing_form containing_form

  sleep 0.25

  SetTerms.where(:set_id => set.id, :term_id => idiom.id).count.should == 0
end
