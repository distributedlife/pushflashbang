Feature: inconsistent schedule
  In order to separate cards that are originally scheduled together
  As a language learner
  I want cards to be scheduled at the next interval plus or minus 5 minutes as
    long as the inteval is greater than or equal to 1 hour

  Background:
    Given I am logged in and have created a deck
    And I have created many cards in the deck
    And reference data has been loaded

  Scenario: interval is less than 2 minutes
    When I have reviewed a card with an interval of 25
    When I click on the "third" button
    And the card interval should be 120

  Scenario: interval is 10 minutes
    When I have reviewed a card with an interval of 600
    When I click on the "third" button
    Then the interval should be 3600 to the next plus or minus 60 seconds

  Scenario: interval is > 10 minutes
    When I have reviewed a card with an interval of 601
    When I click on the "third" button
    Then the interval should be 3600 to the next plus or minus 60 seconds
