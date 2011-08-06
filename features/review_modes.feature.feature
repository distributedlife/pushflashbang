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
    And the user has the "greetings" set as a goal for the "English" language


#  Scenario: selecting a review mode of "listening" sets the correct review types
#    When review the "greetings" set in "English" using the "listening" review mode
#    Then

#  Scenario: selecting a review mode of "listen and write" sets the correct review types
#
#  Scenario: selecting a review mode of "listen and type" sets the correct review types
#
#  Scenario: selecting a review mode of "reading" sets the correct review types
#
#  Scenario: selecting a review mode of "read and speak" sets the correct review types
#
#  Scenario: selecting a review mode of "read, speak and type" sets the correct review types
#
#  Scenario: selecting a review mode of "speaking" sets the correct review types
#
#  Scenario: selecting a review mode of "speak and write" sets the correct review types
#
#  Scenario: selecting a review mode of "speak and type" sets the correct review types