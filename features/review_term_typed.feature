@javascript
Feature: review term in typing mode

  Background:
    Given reference data has been loaded
    And the following sets:
      | name      | description                                    |
      | greetings | learn how to greet someone in another language |
    And the following related translations:
      | form         | language | pronunciation |
      | un poco de   | Spanish  |               |
      | a little bit | English  |               |
    And the group containing "a little bit" is in the set "greetings"
    And the user has the "greetings" set as a goal for the "Spanish" language

    Scenario: typing review handles correct answer and compares to native
    When I review the "greetings" set in "Spanish" using the "translating, speaking and typing" review mode
    And I typed "un poco de" in as the answer
    When I reveal the answer
    And show me the page
    Then I will be told I am correct
    And I should see a "typing" checkbox and it is checked

  Scenario: typing review handles incorrect answer and compares to native
    Given I review the "greetings" set in "Spanish" using the "translating, speaking and typing" review mode
    And I typed "bajo" in as the answer
    When I reveal the answer
    Then I will be told I am not correct
    And I should see a "typing" checkbox and it is not checked