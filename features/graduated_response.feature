Feature: Graduated Response
  In order to more accurately reflect my ability to remember
  As a language learner
  I want to have more options in how I respond to a flash card answer

  Background:
    Given I am logged in and have created a deck
    And I have created many cards in the deck
    And reference data has been loaded

  Scenario: four options
    When I have reviewed a card
    Then I should see "I didn't know the answer"
    Then I should see "I knew some of the answer"
    Then I should see "I was shaky but I got it"
    Then I should see "I knew the answer"

  @javascript
  Scenario: new card green button indicator
    When I have reviewed a new card
    Then the "first" button is highlighted
    And the "second" button is normal
    And the "third" button is normal
    And the "fourth" button is normal

  @javascript
  Scenario: existing card green button indicator
    When I take 2 seconds to review a card that is not new
    Then the "first" button is normal
    And the "second" button is normal
    And the "third" button is highlighted
    And the "fourth" button is normal

  @javascript
  Scenario: perfect card green button indicator
    When I take 0 seconds to review a card that is not new
    Then the "first" button is normal
    And the "second" button is normal
    And the "third" button is normal
    And the "fourth" button is highlighted

  @javascript
  Scenario: the first button counts as failed review
    Given I have reviewed a card
    When I click on the "first" button
    Then I should be on the "deck session" page
    And the card should be rescheduled
    And the card interval should be reset

  @javascript
  Scenario: the second button counts as failed review
    Given I have reviewed a card
    When I click on the "second" button
    Then I should be on the "deck session" page
    And the card should be rescheduled
    And the card interval should be reset

  @javascript
  Scenario: the third button counts as a successful review
    Given I have reviewed a card
    When I click on the "third" button
    Then I should be on the "deck session" page
    And the card should be rescheduled
    And the card interval should be increased

  @javascript
  Scenario: the fourth button counts as a successful review
    Given I have reviewed a card
    When I click on the "fourth" button
    Then I should be on the "deck session" page
    And the card should be rescheduled
    And the card interval should be increased to minimum
    