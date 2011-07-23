And /^I know the following languages: "([^"]*)"$/ do |languages|
  languages.split(',').each do |language_name|
    language_name.strip!

    add_language_to_user language_name
  end
end

And /^the following languages are available: "([^"]*)"$/ do |languages|
  languages.split(',').each do |language_name|
    language_name.strip!

    ensure_language_exists language_name
  end
end

And /^I select "([^"]*)" to learn$/ do |language_name|
  on_page :ShowLanguagesPage, Capybara.current_session do |page|
    language = ensure_language_exists language_name

    page.learn_language language
  end
end

And /^I select "([^"]*)" to stop learning$/ do |language_name|
  on_page :ShowLanguagesPage, Capybara.current_session do |page|
    language = ensure_language_exists language_name

    page.stop_learning_language language
  end
end


And /^my set of languages is: "([^"]*)"$/ do |languages|
  languages.split(',').each do |language_name|
    language_name.strip!

    user_is_learning_language?(language_name).should be true
  end
end

Then /^I should see the following sets on "([^"]*)" language page$/ do |language, table|
  add(:language, get_language(language))

  goto_page :ShowLanguagePage, Capybara.current_session, sut do |page|
    table.hashes.each do |hash|
      page.is_set_on_page hash
    end
  end
end