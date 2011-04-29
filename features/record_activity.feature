Feature: record activity
  So that I can better tailer the system to the user's learning pattern
  As the product owner
  I want to track metrics about how the user learns

  #add is when the card is first schedule
  #due is when a card is due for review
  #review is when a due card is finally displayed to the user
  # the time between due and review may indicate dedication to cards or learning patterns
  #reveal is when the user has requested to see the back of the card
  # the time between review and reveal is how long they looked at the front of the card
  #record is when the user has recorded their result
  # the time between reveal and record is how hard they think about what score they got. This can indicate UX issues

  Background:
    Given I am logged in and have created a deck
    And I have created many items in the deck
    And reference data has been loaded

  Scenario: record time when card is added to schedule
    When a card is scheduled
    Then the date the card is scheduled is recorded

  Scenario: record time between due and reviewed
    Given I have reviewed a card
    When I record my result
    Then the review contains the time the card was due
    And the review contains the time the card was reviewed

  Scenario: record time between review and reveal
    Given I have reviewed a card
    When I record my result
    Then the review contains the time the card was revealed

  Scenario: record time between reveal and record
    Given I have reviewed a card
    When I record my result
    Then the review contains the time the result was recorded
    And the review contains the outcome of the result
    And the review contains the interval of the review

  Scenario: record each and every review a user makes
    Given I have reviewed a card
    And I record my result
    When I review the same card again
    Then there should be two reviews for the same card