Feature: chapters
  In order to have levels of learning
  As a deck creater
  I want to organise my decks into chapters

  Background:
    Given I am logged in and have created a deck
    And I have created many items in the deck
    And reference data has been loaded

  Scenario: view deck with chapters
    Given I have a deck with multiple chapters
    When I am on the show deck page
    Then I should see "Chapter 1"
    Then I should see "Chapter 2"

  Scenario: due card is in current chapter
    Given there are cards due
    And the next due card is in the current chapter
    When I go to the deck session page
    Then the first due card is shown

  Scenario: due card is in next chapter
    Given there are cards due
    And the next due card is in the next chapter
    When I go to the deck session page
    Then I should be on the next chapter page

  Scenario: chapter page redirects to learn if there are due cards
    Given there are cards due
    When I go to the deck chapter page
    Then I should be on the deck session page