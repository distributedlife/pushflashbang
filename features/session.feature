Feature: sessions
  As a language learner
  I want to go through my due cards and new cards
  So that I can better at learning my chosen language

  Background:
    Given I am logged in and have created a deck
    And I have created many items in the deck
    And reference data has been loaded

  Scenario: first session for deck for user
    Given I have not performed any sessions before
    When I go to the deck session page
    Then the first card in the deck is scheduled
    And the first card in the deck is shown

  Scenario: a card is due and there are cards that have not been scheduled
    Given there are cards due
    And there are unscheduled cards
    When I go to the deck session page
    Then the first due card is shown

  Scenario: a card is due and there are no unscheduled cards
    Given there are cards due
    When I go to the deck session page
    Then the first due card is shown

  Scenario: no cards are due there are cards that have not been scheduled
    Given there are no cards due
    And there are cards due later
    And there are unscheduled cards
    When I go to the deck session page
    Then the first unscheduled card is scheduled
    And the first unscheduled card is shown

  Scenario: no cards are due and there are no unscheduled cards
    Given there are no cards due
    And there are no unscheduled cards
    When I go to the deck session page
    Then I should see "There are no cards due and all cards in the deck are scheduled"
    And I should see when each card is scheduled to be reviewed

  Scenario: no cards in deck
    Given there are no cards in the deck
    And I go to the deck session page
    Then I should be redirected to the show deck page
    And I should see "You can't start a session until you have added cards to the deck."

  Scenario: items due count
    Given there are cards due
    When I go to the deck session page
    Then the number of cards due is shown

  Scenario: see card back
    Given I am reviewing a card
    When I click on "Reveal"
    Then I should see the back of the card

  Scenario: review card as a success
    Given I have reviewed a card
    When I click on the "third" button
    Then I should be redirected to the deck session page
    And the card should be rescheduled
    And the card interval should be increased

  @javascript
  Scenario: review card as a failure
    Given I have reviewed a card
    When I click on the "first" button
    Then I should be redirected to the deck session page
    And the card should be rescheduled
    And the card interval should be reset

  Scenario: new card notification
    When a new card is scheduled
    Then I should see "This is a new card. You will not have seen it before"
    Then I should see "New Card"

  Scenario: card review notification
    Given there are cards due
    When I go to the deck session page
    Then I should see "Card Review"
    