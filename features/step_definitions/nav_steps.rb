def string_to_class_symbol string
  string.titleize.delete(' ').to_sym
end

Given /^I go to the "([^"]*)" page$/ do |page_name|
  page_symbol = string_to_class_symbol "#{page_name}_page"

  goto_page page_symbol, Capybara.current_session, sut
end

Then /^I should be on the "([^"]*)" page$/ do |page_name|
  page_symbol = string_to_class_symbol "#{page_name}_page"

  on_page page_symbol, Capybara.current_session
end