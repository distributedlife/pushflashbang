################################################################################
# Data Setup
################################################################################
#And /^I create the following sets:$/ do |table|
#  ensure_user_exists_and_is_logged_in
#
#  table.hashes.each do |hash|
#    create_set(hash)
#  end
#end




################################################################################
# AS USER
################################################################################
And /^I create the following sets:$/ do |table|
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


And /^the following will be visible on the show sets page$/ do |table|
  goto_page :ShowSetPage, Capybara.current_session, sut do |page|
    table.hashes.each do |hash|
      page.is_on_page hash
    end
  end
end
