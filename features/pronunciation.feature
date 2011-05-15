Feature: structured data
  In order to provide more consistent language information
  As a language learner
  I want to provide more structured data in my cards

Background:
  Given I am logged in and have created a deck

Scenario: pronunciation can be shown on front of card if set
  Given I have created a deck
  And the deck is configured to show the pronunciation on the front
  When I am reviewing a card
  Then I should see the pronunciation

Scenario: pronunciation can be shown on back of card if set
  Given I have created a deck
  And the deck is configured to show the pronunciation on the front
  When I am reviewing a card
  Then I should see the pronunciation
