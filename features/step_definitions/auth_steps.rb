Given /^the "([^"]*)" language has been created$/ do |language_name|
  add(:language, create_language(language_name))
end


And /^I create an account for "([^"]*)"$/ do |email|
  password = "password"

  fill_in('user_email', :with => email)
  fill_in('user_password', :with => password)
  fill_in('user_password_confirmation', :with => password)
  select("English", :from => "user_native_language_id")
  click_on("Join!")

  add(:user, User.where(:email => email).first)
  add(:user_id, get(:user).id)
end

And /^I am a new, authenticated user$/ do
  email = 'user@testing.com'
  password = 'password'

  And %{the "English" language has been created}
  And %{I have one user "#{email}" with password "#{password}"}
  And %{I login with "#{email}" and "#{password}"}
end

And /^I have one\s+user "([^\"]*)" with password "([^\"]*)"$/ do |email, password|
  User.new(:email => email, :password => password, :password_confirmation => password, :native_language_id => get(:language).id).save!
end

And /^I login with "([^\"]*)" and "([^\"]*)"$/ do |email, password|
  And %{I go to the "user login" page}
  And %{I fill in "user_email" with "#{email}"}
  And %{I fill in "user_password" with "#{password}"}
  And %{I press "Login"}

  add(:email, email)
  add(:password, password)

  add(:user, User.where(:email => email).first)
end

And /^I log in as "([^"]*)"$/ do |email|
  And %{I login with "#{email}" and "#{get(:password)}"}
end

And /^I log in using a password of "([^"]*)"$/ do |password|
  And %{I login with "#{get(:email)}" and "#{password}"}
end

And /^I change my email address to "([^"]*)"$/ do |email|
  on_page :EditAccountPage, Capybara.current_session do |page|
    page.change_email_address email, get(:password)
  end
end

And /^I change my password to "([^"]*)"$/ do |password|
  on_page :EditAccountPage, Capybara.current_session do |page|
    page.change_password get(:password), password
  end
end

And /^I cancel my account$/ do
  on_page :EditAccountPage, Capybara.current_session do |page|
    page.cancel_account
  end
end

And /^my account should be deleted$/ do
  User.count.should == 0
end