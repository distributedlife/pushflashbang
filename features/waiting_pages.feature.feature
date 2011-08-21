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
    And the user has the "greetings" set as a goal for the "Spanish" language

  Scenario: end of chapter
    Given all terms in the "greetings" set chapter 1 for "Spanish" are scheduled but not due
    When I review the "greetings" set in "Spanish" using the "reading" review mode
    Then I should be on the "next set chapter" page

  Scenario: end of chapter, advance to next
    Given all terms in the "greetings" set chapter 1 for "Spanish" are scheduled but not due
    When I choose to advance to the next chapter
    Then I should be on chapter 2

  Scenario: When I have no chapters to advance to, show end of set page
    Given the term containing "un poco de" in "Spanish" is scheduled but not due
    Given the term containing "one" in "Spanish" is scheduled but not due
    Given the term containing "two" in "Spanish" is scheduled but not due
    When I review the "greetings" set in "Spanish" using the following proficiences:
      | proficiency |
      | reading     |
      | writing     |
    Then I should be on the "completed set" page