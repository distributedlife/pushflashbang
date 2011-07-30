Feature: language features
  In order to easily see the languages I am learning
  As a language learner
  I want my language practice tools organised around my language choices

  Scenario: a new user does not have any language choice
    Given I am a new, authenticated user
    When I go to the "user home" page
    Then I should see "You have not selected to learn any languages."

  Scenario Outline: a user can select a language choice from the list
    Given I know the following languages: "<current languages>"
    And the following languages are available: "<available languages>"
    When I go to the "user languages" page
    And I select "<language to learn>" to learn
    Then my set of languages is: "<set of languages>"

    Examples:
      | current languages | available languages  | language to learn    | set of languages                       |
      | English           | Spanish              | Spanish              | English, Spanish                       |
      | English, Spanish  | Chinese (Simplified) | Chinese (Simplified) | English, Spanish, Chinese (Simplified) |

  Scenario: a user can remove a language choice from the list
    Given I know the following languages: "English, Spanish"
    When I go to the "user languages" page
    And I select "Spanish" to stop learning
    Then my set of languages is: "English"

  Scenario: a user can see their language choices on their home page
    Given I know the following languages: "English, Spanish"
    When I go to the "user home" page
    Then I should see "English"
    And I should see "Spanish"

  Scenario: language page shows all sets in the language
    Given the following languages are available: "English"
    And a set with the following names:
      | name      | description                                    |
      | greetings | learn how to greet someone in another language |
    And the following related translations:
      | form         | language             | pronunciation |
      | un poco de   | Spanish              |               |
      | a little bit | English              |               |
      | 一点儿          | Chinese (Simplified) | yì diǎnr      |
    And the group containing "a little bit" is in the set "greetings"
    Then I should see the following sets on "English" language page
      | name      | description                                    |
      | greetings | learn how to greet someone in another language |