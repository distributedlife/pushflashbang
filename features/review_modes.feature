@javascript
Feature: review modes
  As a language learner
  I want to practice specific language proficiencies
  So that I can improve each proficiency independently

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
    And the user has reviewed the idiom "un poco de" before in the "Spanish" language

  Scenario: selecting a review mode of "listening" sets the correct review types
    When I review the "greetings" set in "Spanish" using the "listening" review mode
    Then the before the reveal the audio is displayed
    And before the reveal the native language is not displayed
    And before the reveal the learned language is not displayed
    And the text answer input control is not shown
    And after the reveal the native language is displayed
    And after the reveal the learned language is displayed

  Scenario: selecting a review mode of "listen and write" sets the correct review types
    When I review the "greetings" set in "Spanish" using the "listening and writing" review mode
    Then the before the reveal the audio is displayed
    And before the reveal the native language is not displayed
    And before the reveal the learned language is not displayed
    And the text answer input control is not shown
    And after the reveal the native language is displayed
    And after the reveal the learned language is displayed

  Scenario: selecting a review mode of "listen and type" sets the correct review types
    When I review the "greetings" set in "Spanish" using the "listening and typing" review mode
    Then the before the reveal the audio is displayed
    And the text answer input control is shown
    And before the reveal the native language is not displayed
    And before the reveal the learned language is not displayed
    And after the reveal the native language is displayed
    And after the reveal the learned language is displayed

  Scenario: selecting a review mode of "reading" sets the correct review types
    When I review the "greetings" set in "Spanish" using the "reading" review mode
    Then before the reveal the learned language is displayed
    And before the reveal the audio is not displayed
    And before the reveal the native language is not displayed
    And the text answer input control is not shown
    And after the reveal the native language is displayed
    And after the reveal the audio is displayed

  Scenario: selecting a review mode of "read and speak" sets the correct review types
    When I review the "greetings" set in "Spanish" using the "reading and speaking" review mode
    Then before the reveal the learned language is displayed
    And before the reveal the audio is not displayed
    And before the reveal the native language is not displayed
    And the text answer input control is not shown
    And after the reveal the native language is displayed
    And after the reveal the audio is displayed

  Scenario: selecting a review mode of "read, speak and type" sets the correct review types
    When I review the "greetings" set in "Spanish" using the "reading, speaking and typing" review mode
    Then before the reveal the learned language is displayed
    And before the reveal the audio is not displayed
    And before the reveal the native language is not displayed
    And the text answer input control is shown
    And after the reveal the native language is displayed
    And after the reveal the audio is displayed

  Scenario: selecting a review mode of "speaking" sets the correct review types
    When I review the "greetings" set in "Spanish" using the "translating and speaking" review mode
    Then before the reveal the native language is displayed
    And before the reveal the audio is not displayed
    And before the reveal the learned language is not displayed
    And the text answer input control is not shown
    And after the reveal the learned language is displayed
    And after the reveal the audio is displayed

  Scenario: selecting a review mode of "speak and write" sets the correct review types
    When I review the "greetings" set in "Spanish" using the "translating, speaking and writing" review mode
    Then before the reveal the native language is displayed
    And before the reveal the audio is not displayed
    And before the reveal the learned language is not displayed
    And the text answer input control is not shown
    And after the reveal the learned language is displayed
    And after the reveal the audio is displayed

  Scenario: selecting a review mode of "speak and type" sets the correct review types
    When I review the "greetings" set in "Spanish" using the "translating, speaking and typing" review mode
    Then before the reveal the native language is displayed
    And before the reveal the audio is not displayed
    And before the reveal the learned language is not displayed
    And the text answer input control is shown
    And after the reveal the learned language is displayed
    And after the reveal the audio is displayed