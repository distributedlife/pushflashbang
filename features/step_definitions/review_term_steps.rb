Given /^the term containing "([^"]*)" in "([^"]*)" is due$/ do |containing_form, language_name|
  idiom = get_idiom_containing_form containing_form
  language = get_language(language_name)


  create_schedule_and_due_items get(:user).id, idiom.id, language.id, 1.day.ago
end

Given /^the term containing "([^"]*)" in "([^"]*)" is scheduled but not due$/ do |containing_form, language_name|
  idiom = get_idiom_containing_form containing_form
  language = get_language(language_name)

  create_schedule_and_due_items get(:user).id, idiom.id, language.id, 1.day.from_now
end

Given /^I typed "([^"]*)" in as the answer$/ do |answer|
  on_page :ReviewTermPage, Capybara.current_session do |page|
    page.set_text_answer answer
  end
end

Given /^all terms in the "([^"]*)" set chapter (\d+) for "([^"]*)" are scheduled but not due$/ do |set_name, chapter, language_name|
  add(:set, get_set_from_name(set_name))
  add(:language, get_language(language_name))

  SetTerms.where(:set_id => get(:set).id, :chapter => chapter.to_s).each do |set_term|
    schedule = UserIdiomSchedule.where(:user_id => get(:user).id, :idiom_id => set_term.term_id)
    if schedule.empty?
      create_schedule_and_due_items get(:user).id, set_term.term_id, get(:language).id, 1.day.from_now
    else
      schedule = schedule.first
      UserIdiomDueItems.where(:user_idiom_schedule_id => schedule.id, :user_id => get(:user).id).each do |due_item|
        due_item.due = 1.day.from_now
        due_item.save!
      end
    end
  end
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

When /^I review the "([^"]*)" set in "([^"]*)" using the "([^"]*)" review mode$/ do |set_name, language_name, review_mode|
  add(:set, get_set_from_name(set_name))
  add(:language, get_language(language_name))

  goto_page :ShowLanguageSetPage, Capybara.current_session, sut do |page|
    page.select_review_mode review_mode
  end
end

When /^I reveal the answer I will be told I am correct$/ do
  on_page :ReviewTermPage, Capybara.current_session do |page|
    page.reveal!
    page.is_answer_correct?.should be true
  end
end

When /^I reveal the answer I will be told I am incorrect$/ do
  on_page :ReviewTermPage, Capybara.current_session do |page|
    page.reveal!
    page.is_answer_incorrect?.should be true
  end
end

When /^I reveal the answer$/ do
  on_page :ReviewTermPage, Capybara.current_session do |page|
    page.reveal!
  end
end

When /^I reveal the answer after (\d+) seconds$/ do |seconds|
  sleep seconds.to_i
  
  on_page :ReviewTermPage, Capybara.current_session do |page|
    page.reveal!
  end
end

When /^I reveal in under (\d+) seconds$/ do |seconds|
  on_page :ReviewTermPage, Capybara.current_session do |page|
    page.reveal!
  end
end

When /^I submit the following results$/ do |table|
  on_page :ReviewTermPage, Capybara.current_session do |page|
    table.hashes.each do |hash|
      page.set_check_box(hash["review type"], hash["result"])
    end

    page.do_record_review
  end
end

When /^I submit the following results as perfect$/ do |table|
  on_page :ReviewTermPage, Capybara.current_session do |page|
    table.hashes.each do |hash|
      page.set_check_box(hash["review type"], hash["result"])
    end

    page.do_record_review_perfect
  end
end

When /^I choose to advance to the next chapter$/ do
  add(:review_mode, "reading")
  
  goto_page :ShowLanguageSetPage, Capybara.current_session, sut do |page|
    page.select_review_mode get(:review_mode)
  end

  on_page :NextSetChapterPage, Capybara.current_session do |page|
    page.advance!
  end
end


################################################################################
################################################################################
################################################################################

Then /^the first term in the set is scheduled for "([^"]*)"$/ do |review_type|
  UserIdiomSchedule.count.should == 1

  first = UserIdiomSchedule.first
  found = false
  UserIdiomDueItems.where(:user_idiom_schedule_id => first.id).each do |due_item|
    found = true if due_item.review_type == UserIdiomReview.to_review_type_int(review_type)
  end

  found.should == true
end

Then /^the first term in the set is not scheduled for "([^"]*)"$/ do |review_type|
  UserIdiomSchedule.count.should == 1

  first = UserIdiomSchedule.first
  not_found = false
  UserIdiomDueItems.where(:user_idiom_schedule_id => first.id).each do |due_item|
    not_found = true unless due_item.review_type == UserIdiomReview.to_review_type_int(review_type)
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

Then /^the before the reveal the audio is displayed$/ do
  on_page :ReviewTermPage, Capybara.current_session do |page|
    page.is_audio_visible?.should be true
  end
end

Then /^before the reveal the audio is not displayed$/ do
  on_page :ReviewTermPage, Capybara.current_session do |page|
    page.is_audio_hidden?.should be true
  end
end

Then /^after the reveal the audio is displayed$/ do
  on_page :ReviewTermPage, Capybara.current_session do |page|
    page.reveal!
    page.is_audio_visible?.should be true
  end
end

Then /^before the reveal the native language is not displayed$/ do
  on_page :ReviewTermPage, Capybara.current_session do |page|
    page.native_language_is_hidden?.should be true
  end
end

Then /^before the reveal the learned language is not displayed$/ do
  on_page :ReviewTermPage, Capybara.current_session do |page|
    page.learned_language_is_hidden?.should be true
  end
end

Then /^before the reveal the native language is displayed$/ do
  idiom = get(:idiom)
  #TODO: make this work with user.language
  language = get_language "English"

  idiom_translations = get_translation_group_using_idiom idiom

  on_page :ReviewTermPage, Capybara.current_session do |page|
    idiom_translations.each do |idiom_translation|
      if idiom_translation.translation.language_id == language.id
        page.native_language_contains?(idiom_translation.translation.form).should be true
      end
    end
  end
end

Then /^before the reveal the learned language is displayed$/ do
  idiom = get(:idiom)
  language = get(:language)

  idiom_translations = get_translation_group_using_idiom idiom

  on_page :ReviewTermPage, Capybara.current_session do |page|
    idiom_translations.each do |idiom_translation|
      if idiom_translation.translation.language_id == language.id
        page.learned_language_contains?(idiom_translation.translation.form).should be true
      end
    end
  end
end

Then /^after the reveal the native language is displayed$/ do
  idiom = get(:idiom)
  #TODO: make this work with user.language
  language = get_language "English"

  idiom_translations = get_translation_group_using_idiom idiom

  on_page :ReviewTermPage, Capybara.current_session do |page|
    page.reveal!

    idiom_translations.each do |idiom_translation|
      if idiom_translation.translation.language_id == language.id
        page.native_language_contains?(idiom_translation.translation.form).should be true
      end
    end
  end
end

Then /^after the reveal the learned language is displayed$/ do
  idiom = get(:idiom)
  language = get(:language)

  idiom_translations = get_translation_group_using_idiom idiom

  on_page :ReviewTermPage, Capybara.current_session do |page|
    page.reveal!
    idiom_translations.each do |idiom_translation|
      if idiom_translation.translation.language_id == language.id
        page.learned_language_contains?(idiom_translation.translation.form).should be true
      end
    end
  end
end

Then /^the text answer input control is shown$/ do
  on_page :ReviewTermPage, Capybara.current_session do |page|
    page.text_input_is_visible?.should be true
  end
end

Then /^the text answer input control is not shown$/ do
  on_page :ReviewTermPage, Capybara.current_session do |page|
    page.text_input_is_hidden?.should be true
  end
end

Then /^I will be told I am correct$/ do
  on_page :ReviewTermPage, Capybara.current_session do |page|
    page.is_answer_correct?.should be true
  end
end

Then /^I will be told I am not correct$/ do
  on_page :ReviewTermPage, Capybara.current_session do |page|
    page.is_answer_incorrect?.should be true
  end
end

Then /^I should see a "([^"]*)" checkbox and it is checked$/ do |review_type|
  on_page :ReviewTermPage, Capybara.current_session do |page|
    page.answer_control_is_set_as?(review_type, true)
  end
end

Then /^I should see a "([^"]*)" checkbox and it is not checked$/ do |review_type|
  on_page :ReviewTermPage, Capybara.current_session do |page|
    page.answer_control_is_set_as?(review_type, false)
  end
end

Then /^I should see the "([^"]*)" button$/ do |button_name|
  on_page :ReviewTermPage, Capybara.current_session do |page|
    page.button_exists? button_name
  end
end

Then /^I the term containing "([^"]*)" for language "([^"]*)" should have a successful "([^"]*)" review$/ do |containing_form, language_name, review_type|
  sleep 0.25
  
  idiom = get_idiom_containing_form containing_form
  language = get_language(language_name)

  review = UserIdiomReview.where(:idiom_id => idiom.id, :user_id => get(:user).id, :language_id => language.id, :review_type => UserIdiomReview.to_review_type_int(review_type))
  review.first.success.should be true
end

Then /^I the term containing "([^"]*)" for language "([^"]*)" should have an unsuccessful "([^"]*)" review$/ do |containing_form, language_name, review_type|
  sleep 0.25

  idiom = get_idiom_containing_form containing_form
  language = get_language(language_name)

  review = UserIdiomReview.where(:idiom_id => idiom.id, :user_id => get(:user).id, :language_id => language.id, :review_type => UserIdiomReview.to_review_type_int(review_type))
  review.first.success.should be false
end

Then /^I should be on chapter (\d+)$/ do |chapter|
  user_set = UserSets.where(:user_id => get(:user).id, :set_id => get(:set).id).first
  user_set.chapter.should == chapter.to_i
end

