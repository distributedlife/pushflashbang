Feature: Set goals
  In order to focus on certain sets
  As a language learner
  I want to specify sets as goals

  Scenario: user can specify set as a goal
    Given the following sets:
      | name      | description                                    |
      | greetings | learn how to greet someone in another language |
      | farewells | learn how to farewell someone in another language |
    And the following related translations:
      | form         | language             | pronunciation |
      | un poco de   | Spanish              |               |
      | a little bit | English              |               |
      | 一点儿          | Chinese (Simplified) | yì diǎnr      |
    When I add the group containing "a little bit" to the set "greetings"
    When I add the group containing "a little bit" to the set "farewells"
    When I choose the set "greetings" as a goal
    Then the following sets are listed as user goals on the "English" language page:
      | name |
      | greetings |
    And the following sets are listed as potential goals on the "English" language page:
      | name |
      | farewells |

#  Scenario: user can see goal progress