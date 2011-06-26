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

Then /^my set of languages is: "([^"]*)"$/ do |languages|
  languages.split(',').each do |language_name|
    language_name.strip!

    user_is_learning_language?(language_name).should be true
  end
end
