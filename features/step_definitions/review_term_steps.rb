Given /^the term containing "([^"]*)" in "([^"]*)" is due$/ do |containing_form, language_name|
  idiom = get_idiom_containing_form containing_form
  language = get_language(language_name)

  schedule = UserIdiomSchedule.create(:user_id => get(:user).id, :idiom_id => idiom.id, :language_id => language.id)
  UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :due => 1.day.ago, :review_type => 1, :interval => CardTiming.first.seconds)
  UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :due => 1.day.ago, :review_type => 2, :interval => CardTiming.first.seconds)
  UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :due => 1.day.ago, :review_type => 4, :interval => CardTiming.first.seconds)
  UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :due => 1.day.ago, :review_type => 8, :interval => CardTiming.first.seconds)
  UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :due => 1.day.ago, :review_type => 16, :interval => CardTiming.first.seconds)
end

Given /^the term containing "([^"]*)" in "([^"]*)" is scheduled but not due$/ do |containing_form, language_name|
  idiom = get_idiom_containing_form containing_form
  language = get_language(language_name)

  schedule = UserIdiomSchedule.create(:user_id => get(:user).id, :idiom_id => idiom.id, :language_id => language.id)
  UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :due => 1.day.from_now, :review_type => 1, :interval => CardTiming.first.seconds)
  UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :due => 1.day.from_now, :review_type => 2, :interval => CardTiming.first.seconds)
  UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :due => 1.day.from_now, :review_type => 4, :interval => CardTiming.first.seconds)
  UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :due => 1.day.from_now, :review_type => 8, :interval => CardTiming.first.seconds)
  UserIdiomDueItems.create(:user_idiom_schedule_id => schedule.id, :due => 1.day.from_now, :review_type => 16, :interval => CardTiming.first.seconds)
end


################################################################################
################################################################################
################################################################################

When /^I review the "([^"]*)" set in "([^"]*)" for the first time using the following proficiences:$/ do |set_name, language_name, table|
  add(:set, get_set_from_name(set_name))
  add(:language, get_language(language_name))

  review_mode = ""
  table.hashes.each do |hash|
    review_mode = "#{review_mode},#{hash[:proficiency]}"
  end
  add(:review_mode, review_mode)

  goto_page :ReviewSetPage, Capybara.current_session, sut
end

When /^I review the "([^"]*)" set in "([^"]*)" using the following proficiences:$/ do |set_name, language_name, table|
  add(:set, get_set_from_name(set_name))
  add(:language, get_language(language_name))

  review_mode = ""
  table.hashes.each do |hash|
    review_mode = "#{review_mode},#{hash[:proficiency]}"
  end
  add(:review_mode, review_mode)

  goto_page :ReviewSetPage, Capybara.current_session, sut
end


################################################################################
################################################################################
################################################################################

Then /^the first term in the set is scheduled for "([^"]*)"$/ do |review_type|
  UserIdiomSchedule.count.should == 1

  if review_type == 'reading'
    review_type_num = 1
  end
  if review_type == 'writing'
    review_type_num = 2
  end
  if review_type == 'typing'
    review_type_num = 4
  end
  if review_type == 'listening'
    review_type_num = 8
  end
  if review_type == 'speaking'
    review_type_num = 16
  end


  first = UserIdiomSchedule.first
  found = false
  UserIdiomDueItems.where(:user_idiom_schedule_id => first.id).each do |due_item|
    found = true if due_item.review_type == review_type_num
  end

  found.should == true
end

Then /^the first term in the set is not scheduled for "([^"]*)"$/ do |review_type|
  UserIdiomSchedule.count.should == 1

  if review_type == 'reading'
    review_type_num = 1
  end
  if review_type == 'writing'
    review_type_num = 2
  end
  if review_type == 'typing'
    review_type_num = 4
  end
  if review_type == 'listening'
    review_type_num = 8
  end
  if review_type == 'speaking'
    review_type_num = 16
  end


  first = UserIdiomSchedule.first
  not_found = false
  UserIdiomDueItems.where(:user_idiom_schedule_id => first.id).each do |due_item|
    not_found = true unless due_item.review_type == review_type_num
  end

  not_found.should == true
end

Then /^the first scheduled term is shown$/ do
  on_page :ReviewTermPage, Capybara.current_session do |page|
    page.is_term(UserIdiomSchedule.first.idiom_id)
  end
end

Then /^the term containing "([^"]*)" shown$/ do |containing_form|
  idiom = get_idiom_containing_form containing_form

  on_page :ReviewTermPage, Capybara.current_session do |page|
    page.is_term(idiom.id)
  end
end
