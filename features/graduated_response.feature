Feature: Graduated Response
  In order to more accurately reflect my ability to remember
  As a language learner
  I want to have more options in how I respond to a flash card answer

  Background:
    Given I am logged in and have created a deck
    And I have created many items in the deck
    And reference data has been loaded

  Scenario: four options
    When I have reviewed a card
    Then I should see "I didn't know the answer"
    Then I should see "I knew some of the answer"
    Then I should see "I was shaky but I got it"
    Then I should see "I knew the answer"

  Scenario: green button indicator (1/4)
    When I have reviewed a card with an interval of 0
    Then the "first" button is "positive"
    And the "second" button is "neutral"
    And the "third" button is "neutral"
    And the "fourth" button is "neutral"

  Scenario: green button indicator (2/4)
    When I have reviewed a card with an interval of 5
    Then the "first" button is "neutral"
    And the "second" button is "positive"
    And the "third" button is "neutral"
    And the "fourth" button is "neutral"

  Scenario: green button indicator (2/4)
    When I have reviewed a card with an interval of 25
    Then the "first" button is "neutral"
    And the "second" button is "positive"
    And the "third" button is "neutral"
    And the "fourth" button is "neutral"

  Scenario: green button indicator (3/4)
    When I have reviewed a card with an interval of 120
    Then the "first" button is "neutral"
    And the "second" button is "neutral"
    And the "third" button is "positive"
    And the "fourth" button is "neutral"

  Scenario: green button indicator (3/4)
    When I have reviewed a card with an interval of 600
    Then the "first" button is "neutral"
    And the "second" button is "neutral"
    And the "third" button is "positive"
    And the "fourth" button is "neutral"

  Scenario: green button indicator (4/4)
    When I have reviewed a card with an interval of 601
    Then the "first" button is "neutral"
    And the "second" button is "neutral"
    And the "third" button is "neutral"
    And the "fourth" button is "positive"

  Scenario: the first button counts as failed review
    Given I have reviewed a card
    When I click on the "first" button
    Then I should be redirected to the deck session page
    And the card should be rescheduled
    And the card interval should be reset

  Scenario: the second button counts as failed review
    Given I have reviewed a card
    When I click on the "second" button
    Then I should be redirected to the deck session page
    And the card should be rescheduled
    And the card interval should be reset

  Scenario: the third button counts as a successful review
    Given I have reviewed a card
    When I click on the "third" button
    Then I should be redirected to the deck session page
    And the card should be rescheduled
    And the card interval should be increased

  Scenario: the fourth button counts as a successful review
    Given I have reviewed a card
    When I click on the "fourth" button
    Then I should be redirected to the deck session page
    And the card should be rescheduled
    And the card interval should be increased