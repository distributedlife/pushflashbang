Feature: review terms
  As a language learner
  I want to go to be shown terms that I need to practice
  So that I can get better at learning my chosen language

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
    And the user has the "greetings" set as a goal for the "English" language

  Scenario: first session for set
    When I review the "greetings" set in "English" for the first time using the following proficiences:
      | proficiency |
      | reading     |
      | writing     |
    Then the first term in the set is scheduled for "reading"
    And the first term in the set is scheduled for "writing"
    And the first term in the set is not scheduled for "typing"
    And the first term in the set is not scheduled for "speaking"
    And the first term in the set is not scheduled for "listening"
    And I should be on the "review term" page
    And the first scheduled term is shown

  Scenario: all review modes are set
    When I review the "greetings" set in "English" for the first time using the following proficiences:
      | proficiency |
      | reading     |
      | writing     |
      | typing      |
      | speaking    |
      | listening   |
    Then the first term in the set is scheduled for "reading"
    And the first term in the set is scheduled for "writing"
    And the first term in the set is scheduled for "typing"
    And the first term in the set is scheduled for "speaking"
    And the first term in the set is scheduled for "listening"
    And I should be on the "review term" page
    And the first scheduled term is shown

  Scenario: When I have due cards, then the first due card is shown
    Given the term containing "un poco de" in "English" is due
    When I review the "greetings" set in "English" using the following proficiences:
      | proficiency |
      | reading     |
      | writing     |
    Then I should be on the "review term" page
    And the term containing "un poco de" shown

  Scenario: When I have no due terms, then the next term is scheduled
    Given the term containing "un poco de" in "English" is scheduled but not due
    When I review the "greetings" set in "English" using the following proficiences:
      | proficiency |
      | reading     |
      | writing     |
    Then I should be on the "review term" page
    And the term containing "one" shown

  Scenario: When I have no due terms and all terms are scheduled show set-chapter advance
    Given the term containing "un poco de" in "English" is scheduled but not due
    Given the term containing "one" in "English" is scheduled but not due
    When I review the "greetings" set in "English" using the following proficiences:
      | proficiency |
      | reading     |
      | writing     |
    Then I should be on the "next set chapter" page

  Scenario: When I have no chapters to advance to, show end of set page
    Given the term containing "un poco de" in "English" is scheduled but not due
    Given the term containing "one" in "English" is scheduled but not due
    Given the term containing "two" in "English" is scheduled but not due
    When I review the "greetings" set in "English" using the following proficiences:
      | proficiency |
      | reading     |
      | writing     |
    Then I should be on the "completed set" page



  #make sure the page is formatting correctly
#  Scenario: front is audio when listening review type is set
#
#  Scenario: front is learning when reading review type is set
#
#  Scenario: front is native when neither reading nor listening review type is set
#
#  Scenario: back is native when review type is listening
#
#  Scenario: back is native when review type is reading
#
#  Scenario: back is learning when review type is writing
#
#  Scenario: back is learning when review type is typing

  # handling audio edge cases
#  Scenario: back is audio when review type is not listening and audio exists
#
#  Scenario: no audio on back is shown when type is not listening and no audio exists
#
#  Scenario: listening review without audio tells user and shows skip to next card

  # handling typing correctly
#  Scenario: typing review shows typing answer space on front
#
#  Scenario: typing review handles correct answer and compares to native
#
#  Scenario: typing review handles incorrect answer and compares to native
