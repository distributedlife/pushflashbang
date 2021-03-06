Feature: deck cards
  As a language learner
  I want decks to have flash cards
  So that I can use flash card SRS learning

  Background:
    Given I am logged in and have created a deck

  Scenario: create card link is available from show deck page
    Given I go to the "show deck" page
    When I click on "Add Card"
    Then I should be on the "add card" page

  Scenario: create card for deck
    Given I go to the "add card" page
    When I create a card
    Then I should be on the "add card" page
    And the form is empty

  Scenario: can't created card without front
    Given I go to the "add card" page
    When I create a card without a front
    And I click on "Save"
    Then I should see "can't be blank"

  Scenario: edit card on deck
    Given I have created a card
    And I go to the "edit card" page
    When I change all deck properties
    And I click on "Save"
    Then I should be on the "show card" page
    And I can see the card changes

  Scenario: remove card from deck
    Given I have created a card
    And I go to the "edit card" page
    When I click on "Delete"
    Then the card should be deleted
    And I should be on the "show deck" page