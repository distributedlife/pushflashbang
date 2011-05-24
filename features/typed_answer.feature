Feature: typed answer feature
  In order to improve my typing ability
  As a language learner
  I want to type my answer in and see whether I got it correct

  Background:
    Given I am logged in and have created a deck
    And I have created many cards in the deck
    And reference data has been loaded

  Scenario: Deck is setup for typed answers
    Given I have created a deck
    And the deck is configured for typed answers
    And there are cards due
    When I go to the "deck session" page
    Then I should see an input field to type my answer

  Scenario: Typed answer matches back of card
    Given I have created a deck
    And the deck is configured for typed answers
    And there are cards due
    When I go to the "deck session" page
    When I type the answer correctly
    And I click on "Reveal"
    Then I should see my answer was correct

  Scenario: Typed answer does not match back of card
    Given I have created a deck
    And the deck is configured for typed answers
    And there are cards due
    When I go to the "deck session" page
    When I type the answer correctly
    And I click on "Reveal"
    Then I should see my answer was incorrect