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
    And the group containing "a little bit" is in the set "greetings"
    And the group containing "a little bit" is in the set "farewells"
    When I choose the set "greetings" for the "English" language as a goal
    Then the following sets are listed as user goals on the "English" language page:
      | name |
      | greetings |
    And the following sets are listed as potential goals on the "English" language page:
      | name |
      | farewells |

  Scenario: user can specify remove a goal
    Given the following sets:
      | name      | description                                    |
      | greetings | learn how to greet someone in another language |
      | farewells | learn how to farewell someone in another language |
    And the following related translations:
      | form         | language             | pronunciation |
      | un poco de   | Spanish              |               |
      | a little bit | English              |               |
      | 一点儿          | Chinese (Simplified) | yì diǎnr      |
    And the group containing "a little bit" is in the set "greetings"
    And the group containing "a little bit" is in the set "farewells"
    And the user has the "greetings" set as a goal for the "English" language
    And the user has the "farewells" set as a goal for the "English" language
    When I choose to unset "greetings" for the "English" language as a goal
    Then the following sets are listed as user goals on the "English" language page:
      | name |
      | farewells |
    And the following sets are listed as potential goals on the "English" language page:
      | name |
      | greetings |

#  Scenario: user can see goal progress