And /^the following related translations:$/ do |table|
  idiom = create_idiom

  table.hashes.each do |hash|
    create_translation_attached_to_idiom idiom, hash
  end
end

And /^I view all translations$/ do
  goto_page :ShowTranslationsPage, Capybara.current_session, sut
end

And /^all translations are shown grouped and sorted alphabetically by language:$/ do |table|
  on_page :ShowTranslationsPage, Capybara.current_session do |page|
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

When /^I create the following translation:$/ do |table|
  goto_page :AddTranslationPage, Capybara.current_session, sut do |page|
    page.create_translation hash
  end
end


And /^I add the following translations to the group containing "([^"]*)"$/ do |form, table|
  goto_page :ShowTranslationPage, Capybara.current_session, sut do |page|
    #find translation defined by form
    #click on add translation
  end

  on_page :AddTranslationPage, Capybara.current_session, sut do |page|
    table.hashes.each do |hash|
#    create_translation_attached_to_idiom idiom, hash
      page.set_fields hash

    end
  end
#  idiom = get_idiom_containing_form form
#
end

And /^the group containing "([^"]*)" should have the following translations:$/ do |form, table|
  translations = get_translations_using_idiom(get_idiom_containing_form form)

  translations.each do |translation|
    translation_found_in_view = false

    table.hashes.each do |hash|
      if translation.form == hash[:form]
        translation_found_in_view = true
      end

      break if translation_found_in_view
    end

    translation_found_in_view.should be true
  end
end
