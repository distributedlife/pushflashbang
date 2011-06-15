Feature: User accounts
  As a user
  I want to be able to identify myself to the system
  So that my interactions with the system are remembered

Scenario: user can register account and is automatically logged in
  Given I go to the "register account" page
  When I create an account for "user@testingthis.com"
  Then I should be on the "user home" page
  And I should see "Welcome! You have signed up successfully."

#Scenario: create account for the first time
#  When I create a new push flash bang account
#  Then I should be logged in and

  Scenario: user is redirect to site index on logout
  Given I am a new, authenticated user
  When I click on "Logout"
  Then I should be on the "site index" page
  And I should see "Signed out successfully."

  Scenario: user can delete account
  Given I am a new, authenticated user
  And I go to the "edit account" page
  When I cancel my account
  Then my account should be deleted
  And I should be on the "site index" page
  And I should see "Bye! Your account was successfully cancelled. We hope to see you again soon."

  Scenario: user can change their email address
  Given I am a new, authenticated user
  And I go to the "edit account" page
  And I change my email address to "banana@apples.com"
  And I click on "Logout"
  When I log in as "banana@apples.com"
  Then I should be on the "user home" page

  Scenario: user can change their password
  Given I am a new, authenticated user
  And I go to the "edit account" page
  And I change my password to "insecure"
  And I click on "Logout"
  When I log in using a password of "insecure"
  Then I should be on the "user home" page