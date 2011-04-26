Feature: deck cards
  As a language learner
  I want decks to have flash cards
  So that I can use flash card SRS learning

  Background:
    Given I am logged in and have created a deck

  Scenario: create card link is available from show deck page
    Given I am on the show deck page
    When I click on "Add Card"
    Then I should be on the add card page

  Scenario: create card for deck
    Given I am on the add card page
    When I create a card
    Then I am redirected to the add card page
    And the form is empty

  Scenario: created cards can be seen on deck page
    Given I have created a card
    And I am on the show deck page
    Then I can see all cards in this deck

  Scenario: can't created card without front
    Given I am on the add card page
    When I create a card without a front
    And I click on "Add"
    Then I should see "can't be blank"

  Scenario: edit card link is available from show deck page
    Given I have created a card
    And I am on the show card page
    When I click on "Edit Card"
    Then I should be on the edit card page

  Scenario: edit card on deck
    Given I have created a card
    And I am on the edit card page
    When I change all deck properties
    And I click on "Save Changes"
    Then I should be on the show card page
    And I can see the card changes

  Scenario: remove card from deck
    Given I have created a card
    And I am on the edit card page
    When I click on "Delete Card"
    Then the card should be deleted
    And I should be on the show deck page

  Scenario: show cards in deck
    Given I have created multiple cards
    When I am on the show deck page
    Then I should see all cards in the deck