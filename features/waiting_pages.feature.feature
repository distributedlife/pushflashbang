Feature: waiting pages

  Background:
    Given reference data has been loaded
    And the following sets:
      | name      | description                                    |
      | greetings | learn how to greet someone in another language |
    And the following related translations:
      | form         | language | pronunciation |
      | un poco de   | Spanish  |               |
      | a little bit | English  |               |
    And the following related translations:
      | form | language | pronunciation |
      | uno  | Spanish  |               |
      | one  | English  |               |
    And the following related translations:
      | form | language | pronunciation |
      | dos  | Spanish  |               |
      | two  | English  |               |
    And the group containing "a little bit" is in the set "greetings"
    And the group containing "one" is in the set "greetings"
    And the group containing "two" is in the set "greetings" in chapter "2"
    And the user has the "greetings" set as a goal for the "English" language

  Scenario: end of chapter
    Given all terms in the "greetings" set chapter 1 for "English" are scheduled but not due
    When I review the "greetings" set in "English" using the "reading" review mode
    Then I should be on the "next set chapter" page

  Scenario: end of chapter, advance to next
    Given I have reached the end of a chapter
    When I choose to advance to the next chapter
    Then I should be on the next chapter

  Scenario: end of set
    Given all terms in the "greetings" set are scheduled but not due
    When I review the "greetings" set in "English" using the "reading" review mode
    Then I should be on the "completed set" page