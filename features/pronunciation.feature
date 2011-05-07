Feature: structured data
  In order to provide more consistent language information
  As a language learner
  I want to provide more structured data in my cards

Background:
  Given I am logged in and have created a deck

Scenario: pronunciation can be shown on front of card if set
  Given I have a deck where the pronunciation is shown on front
  When I am reviewing a card
  Then I should see the pronunciation

Scenario: pronunciation can be shown on back of card if set
  Given I have a deck where the pronunciation is shown on back
  When I am reviewing a card
  Then I should see the pronunciation
