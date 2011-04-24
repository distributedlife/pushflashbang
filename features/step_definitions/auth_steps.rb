Given /^I am on the register account page$/ do
  visit '/users/sign_up'
end

Given /^I am on the login page$/ do
  visit '/users/sign_in'
end

When /^I create an account for "([^"]*)"$/ do |email|
  password = "password"

  fill_in('user_email', :with => email)
  fill_in('user_password', :with => password)
  fill_in('user_password_confirmation', :with => password)
  click_on("Join!")
end

Given /^I am not authenticated$/ do
  visit('/users/sign_out') # ensure that at least
end

Given /^I have one\s+user "([^\"]*)" with password "([^\"]*)"$/ do |email, password|
  User.new(:email => email,
           :password => password,
           :password_confirmation => password).save!
end

Given /^I am a new, authenticated user$/ do
  email = 'user@testing.com'
  password = 'password'

  Given %{I have one user "#{email}" with password "#{password}"}
  And %{I login with "#{email}" and "#{password}"}
end

Given /^I login with "([^\"]*)" and "([^\"]*)"$/ do |email, password|
  And %{I am on the login page}
  And %{I fill in "user_email" with "#{email}"}
  And %{I fill in "user_password" with "#{password}"}
  And %{I press "Login"}

  current_username = email
  current_password = password
end

Then /^I am redirected to "([^\"]*)"$/ do |url|
    assert [301, 302].include?(@integration_session.status), "Expected status to be 301 or 302, got #{@integration_session.status}"
    location = @integration_session.headers["Location"]
    assert_equal url, location
    visit location
end

Then /^I should be on the user-home page$/ do
  on_page :UserHomePage, Capybara.current_session do |user_home_page|
    user_home_page.is_current_page?.should == true
  end
end

When /^I click log out$/ do
  click_on 'Logout'
end

Then /^I should be on the site index$/ do
  on_page :InfoAboutPage, Capybara.current_session do |page|
    page.is_current_page?.should == true
  end
end

Given /^I go to the edit account page$/ do
  goto_page :EditAccountPage, Capybara.current_session do |page|
    page.is_current_page?.should == true
  end
end

When /^I cancel my account$/ do
  on_page :EditAccountPage, Capybara.current_session do |page|
    page.cancel_account
  end
end

Then /^my account should be deleted$/ do
  User.count.should == 0
end

Given /^I change my email address to "([^"]*)"$/ do |email|
  on_page :EditAccountPage, Capybara.current_session do |page|
    page.change_email_address email
  end
end

Given /^I change my password to "([^"]*)"$/ do |password|
  on_page :EditAccountPage, Capybara.current_session do |page|
    page.change_password password
  end
end


When /^I log in using "([^"]*)"$/ do |email|
  And %{I login with "#{email}" and "#{@current_password}"}

  @current_username = email
end

When /^I log in using a password of "([^"]*)"$/ do |password|
  And %{I login with "#{@current_email}" and "#{@password}"}

  @current_password = password
end
