Then /^the translation "([^"]*)" is related to translation "([^"]*)" by meaning$/ do |t1_form, t2_form|
  t1 = get_translation_using_form(t1_form).first
  t2 = get_translation_using_form(t2_form).last

  related_translations_are_the_same t1.id, t2.id

  translations_are_related_by_meaning?(t1.id, t2.id).should be true
end

Then /^the translation "([^"]*)" is related to translation "([^"]*)" by form$/ do |t1_form, t2_form|
  t1 = get_translation_using_form(t1_form).first
  t2 = get_translation_using_form(t2_form).last

  related_translations_are_the_same t1.id, t2.id
  
  translations_are_related_by_written_form?(t1.id, t2.id).should be true
end

Then /^the translation "([^"]*)" is related to translation "([^"]*)" by pronunciation$/ do |t1_form, t2_form|
  t1 = get_translation_using_form(t1_form).first
  t2 = get_translation_using_form(t2_form).last

  related_translations_are_the_same t1.id, t2.id

  translations_are_related_by_audible_form?(t1.id, t2.id).should be true
end


Then /^the translation "([^"]*)" is not related to translation "([^"]*)" by meaning$/ do |t1_form, t2_form|
  t1 = get_translation_using_form(t1_form).first
  t2 = get_translation_using_form(t2_form).last

  related_translations_are_the_same t1.id, t2.id

  translations_are_related_by_meaning?(t1.id, t2.id).should be false
end


Then /^the translation "([^"]*)" is not related to translation "([^"]*)" by form$/ do |t1_form, t2_form|
  t1 = get_translation_using_form(t1_form).first
  t2 = get_translation_using_form(t2_form).last

  related_translations_are_the_same t1.id, t2.id

  translations_are_related_by_written_form?(t1.id, t2.id).should be false
end

Then /^the translation "([^"]*)" is not related to translation "([^"]*)" by pronunciation$/ do |t1_form, t2_form|
  t1 = get_translation_using_form(t1_form).first
  t2 = get_translation_using_form(t2_form).last

  related_translations_are_the_same t1.id, t2.id

  translations_are_related_by_audible_form?(t1.id, t2.id).should be false
end

Then /^the translation "([^"]*)" is not related to translation "([^"]*)"$/ do |t1_form, t2_form|
  t1 = get_translation_using_form(t1_form).first
  t2 = get_translation_using_form(t2_form).last

  translations_are_not_related t1.id, t2.id
end