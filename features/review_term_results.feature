@javascript
Feature: review term results

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
      | form         | language | pronunciation |
      | uno   | Spanish  |               |
      | one | English  |               |
    And the following related translations:
      | form         | language | pronunciation |
      | dos   | Spanish  |               |
      | two | English  |               |
    And the group containing "a little bit" is in the set "greetings"
    And the group containing "one" is in the set "greetings"
    And the group containing "two" is in the set "greetings" in chapter "2"
    And the user has the "greetings" set as a goal for the "Spanish" language

  Scenario: user review check box exists for each reading, speaking and typing
    Given I review the "greetings" set in "Spanish" using the "reading, speaking and typing" review mode
    When I reveal the answer after 3 seconds
    And I should see the "Record Results" button
    And I should see the "Too Easy! Show me this left often" button
    And I should see a "reading" checkbox and it is not checked
    And I should see a "speaking" checkbox and it is not checked
    And I should see a "typing" checkbox and it is not checked

  Scenario: user review check box exists for each listening and writing
    Given I review the "greetings" set in "Spanish" using the "listening and writing" review mode
    When I reveal the answer after 3 seconds
    And I should see the "Record Results" button
    And I should see the "Too Easy! Show me this left often" button
    And I should see a "listening" checkbox and it is not checked
    And I should see a "writing" checkbox and it is not checked

  Scenario: all options excepting typing are ticked for review under 2 seconds
    Given I review the "greetings" set in "Spanish" using the "reading, speaking and typing" review mode
    When I reveal in under 2 seconds
    And I should see the "Record Results" button
    And I should see the "Too Easy! Show me this left often" button
    And I should see a "reading" checkbox and it is checked
    And I should see a "speaking" checkbox and it is checked
    And I should see a "typing" checkbox and it is not checked

  Scenario: submitted options are recorded
    Given I review the "greetings" set in "Spanish" using the "reading, speaking and typing" review mode
    When I reveal the answer
    When I submit the following results
      | review type | result |
      | reading | checked |
      | speaking | not checked |
      | typing | checked|
    Then I the term containing "un poco de" for language "Spanish" should have a successful "reading" review
    And I the term containing "un poco de" for language "Spanish" should have an unsuccessful "speaking" review
    And I the term containing "un poco de" for language "Spanish" should have a successful "typing" review

  Scenario: submitted options are recorded
    Given I review the "greetings" set in "Spanish" using the "listening and writing" review mode
    When I reveal the answer
    When I submit the following results
      | review type | result |
      | listening | checked |
      | writing | not checked |
    Then I the term containing "un poco de" for language "Spanish" should have a successful "listening" review
    And I the term containing "un poco de" for language "Spanish" should have an unsuccessful "writing" review

  Scenario: submitted options are recorded
    Given I review the "greetings" set in "Spanish" using the "reading and speaking" review mode
    When I reveal the answer
    When I submit the following results as perfect
      | review type | result |
      | reading | not checked |
      | speaking | not checked |
    Then I the term containing "un poco de" for language "Spanish" should have a successful "reading" review
    And I the term containing "un poco de" for language "Spanish" should have a successful "speaking" review