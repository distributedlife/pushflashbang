Feature: inconsistent schedule
  In order to separate cards that are originally scheduled together
  As a language learner
  I want cards to be scheduled at the next interval plus or minus 5 minutes as
    long as the inteval is greater than or equal to 1 hour

#  Scenario: interval is less than 1 hour
#    Given I have reviewed a card
#    And the interval is 600 seconds
#    When I click a positive response
#    Then the interval should be set to the next
#
#  Scenario: interval is 1 hour
#    Given I have reviewed a card
#    And the interval is 3600 seconds
#    When I click a positive response
#    Then the interval should be set to the next plus or minus 300 seconds
#
#  Scenario: interval is > 1 hour
#    Given I have reviewed a card
#    And the interval is 3601 seconds
#    When I click a positive response
#    Then the interval should be set to the next plus or minus 300 seconds
