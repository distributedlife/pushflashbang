def string_to_class_symbol string
  string.titleize.delete(' ').to_sym
end

And /^I am on the "([^"]*)" page$/ do |page_name|
  page_symbol = string_to_class_symbol "#{page_name}_page"

  page = goto_page page_symbol, Capybara.current_session, sut

  add(:page, page)
end

And /^I go to the "([^"]*)" page$/ do |page_name|
  page_symbol = string_to_class_symbol "#{page_name}_page"

  goto_page page_symbol, Capybara.current_session, sut

  add(:page, page)
end

And /^I should be on the "([^"]*)" page$/ do |page_name|
  page_symbol = string_to_class_symbol "#{page_name}_page"

  on_page page_symbol, Capybara.current_session do |page|
    unless page.is_current_page?
      And %{show me the page}
    end

    page.is_current_page?.should be true
  end
  
  add(:page, page)
end