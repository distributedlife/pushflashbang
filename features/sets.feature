Feature: Sets and Goals
  In order to set goals on what I want to learn
  As a language learner
  I want idioms to be organised into sets

  Scenario: created sets are shown sorted alphabetically by name
    When I create the following sets:
      | name          | description                                          |
      | greetings     | learn how to greet someone in another language       |
      | do you speak? | learn how to ask someone if they speak your language |
    Then the following will be visible on the show sets page
      | name          | description                                          |
      | do you speak? | learn how to ask someone if they speak your language |
      | greetings     | learn how to greet someone in another language       |

  #akephalos can't do js scenarios
#  Scenario: name a set multiple times
#    When I create a set with the following:
#      | name      | description                                    |
#      | greetings | learn how to greet someone in another language |
#      | saludos   | aprenda saludos n lenguas differentes |
#    Then the following will be visible on the show sets page
#      | name      | description                                    |
#      | greetings | learn how to greet someone in another language |
#      | saludos   | aprenda saludos n lenguas differentes |

  Scenario: delete a set name
    Given a set with the following names:
      | name      | description                                    |
      | greetings | learn how to greet someone in another language |
      | saludos   | aprenda saludos n lenguas differentes |
    When I delete the set name "greetings"
    Then the following will be visible on the show sets page
      | name          | description                                          |
      | saludos   | aprenda saludos n lenguas differentes |
    And the following will not be visible on the show sets page
      | name          | description                                          |
      | greetings | learn how to greet someone in another language |

  Scenario: delete a set
    Given the following sets:
      | name          | description                                          |
      | do you speak? | learn how to ask someone if they speak your language |
      | greetings     | learn how to greet someone in another language       |
    When I delete the set called "greetings"
    Then the following will be visible on the show sets page
      | name          | description                                          |
      | do you speak? | learn how to ask someone if they speak your language |

  Scenario: edit a set
    Given the following sets:
      | name      | description                                    |
      | greetings | learn how to greet someone in another language |
    When I edit the set called "greetings" to:
      | name      | description                                    |
      | do you speak? | learn how to ask someone if they speak your language |
    Then the following will be visible on the show sets page
      | name          | description                                          |
      | do you speak? | learn how to ask someone if they speak your language |

#   the following can't be done until the capybara/akephalos bug is fixed
#  Scenario: edit and add a name

  Scenario: add a term to a set (from term)
    Given the following sets:
      | name      | description                                    |
      | greetings | learn how to greet someone in another language |
    And the following related translations:
      | form         | language             | pronunciation |
      | un poco de   | Spanish              |               |
      | a little bit | English              |               |
      | 一点儿          | Chinese (Simplified) | yì diǎnr      |
    When I add the group containing "a little bit" to the set "greetings"
    Then the following will be visible on the show set page
      | form         | language             | pronunciation |
      | un poco de   | Spanish              |               |
      | a little bit | English              |               |
      | 一点儿          | Chinese (Simplified) | yì diǎnr      |

  Scenario: add a term to a set (from set)
    Given the following sets:
      | name      | description                                    |
      | greetings | learn how to greet someone in another language |
    And the following related translations:
      | form         | language             | pronunciation |
      | un poco de   | Spanish              |               |
      | a little bit | English              |               |
      | 一点儿          | Chinese (Simplified) | yì diǎnr      |
    And I am on viewing the set "greetings"
    When I add the group containing "a little bit" to the current set
    Then the following will be visible on the show set page
      | form         | language             | pronunciation |
      | un poco de   | Spanish              |               |
      | a little bit | English              |               |
      | 一点儿          | Chinese (Simplified) | yì diǎnr      |

  Scenario: remove a term to a set
    Given the following sets:
      | name      | description                                    |
      | greetings | learn how to greet someone in another language |
    And the following related translations attached to the "greetings" set:
      | form         | language             | pronunciation |
      | un poco de   | Spanish              |               |
      | a little bit | English              |               |
    And the following related translations attached to the "greetings" set:
      | form  | language             | pronunciation |
      | Hello | Gibberish              |               |
      | 你好    | Chinese (Simplified) | nǐ hǎo        |
    When I remove the group containing "a little bit" to the set "greetings"
    Then the following will be visible on the show set page
      | form  | language             | pronunciation |
      | Hello | Gibberish              |               |
      | 你好    | Chinese (Simplified) | nǐ hǎo        |
    Then the following will be not visible on the show set page
      | form  | language             | pronunciation |
      | a little bit | English              |               |
      | un poco de   | Spanish              |               |


#  Scenario: user can specify set as a goal
#  Scenario: user can see goal progress
