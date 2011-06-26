Feature:
  In order to reduce the maintability of learnable words
  As a content creator
  I want words to be made available to everyone

#  Background:
#    Given I am logged in and have created a deck

#  Scenario: created words can be seen by all
#    Given the following related translations:
#      | form         | language             | pronunciation |
#      | un poco de   | Spanish              |               |
#      | a little bit | English              |               |
#      | 一点儿          | Chinese (Simplified) | yì diǎnr      |
#    And the following related translations:
#      | form         | language             | pronunciation |
#      | Hello        | English              |               |
#      | 你好           | Chinese (Simplified) | nǐ hǎo        |
#    And the following related translations:
#      | form         | language             | pronunciation |
#      | Adios        | Spanish              |               |
#    When I view all translations
#    Then all translations are shown grouped and sorted alphabetically by language:
#      | form         | language             | pronunciation |
#      | 一点儿          | Chinese (Simplified) | yì diǎnr      |
#      | a little bit | English              |               |
#      | un poco de   | Spanish              |               |
#      | 你好           | Chinese (Simplified) | nǐ hǎo        |
#      | Hello        | English              |               |
#      | Adios        | Spanish              |               |

#   Scenario: newly created words are not attached to an existing idiom
#    When I create the following translation:
#      | form         | language             | pronunciation |
#      | Adios        | Spanish              |               |
#    Then the translation is attached to a newly created idiom

#  Scenario: created words can be filtered by supported language
#    And the following related translations:
#      | form         | language             | pronunciation |
#      | un poco de   | Spanish              |               |
#      | a little bit | English              |               |
#      | 一点儿          | Chinese (Simplified) | yì diǎnr      |
#    And the following related translations:
#      | form         | language             | pronunciation |
#      | Hello        | English              |               |
#      | 你好           | Chinese (Simplified) | nǐ hǎo        |
#    And the following related translations:
#      | form         | language             | pronunciation |
#      | Adios        | Spanish              |               |
#    When I view translations filted by "English"
#    Then I should see the following translations:
#      | form         | language | pronunciation |
#      | a little bit | English  |               |
#      | Hello        | English  |               |
#
#  Scenario: created words can be filtered by unsupported language
#    And the following related translations:
#      | form         | language             | pronunciation |
#      | un poco de   | Spanish              |               |
#      | a little bit | English              |               |
#      | 一点儿          | Chinese (Simplified) | yì diǎnr      |
#    And the following related translations:
#      | form         | language             | pronunciation |
#      | Hello        | English              |               |
#      | 你好           | Chinese (Simplified) | nǐ hǎo        |
#    And the following related translations:
#      | form         | language             | pronunciation |
#      | Adios        | Spanish              |               |
#    When I view translations filted by "English"
#    Then I should see the following translations:
#      | form  | language | pronunciation |
#      | Adois | Spanish  |               |

#  Scenario: a translation can be added to existing related translations
#    Given the following related translations:
#      | form         | language | pronunciation |
#      | un poco de   | Spanish  |               |
#      | a little bit | English  |               |
#    When I add the following translations to the group containing "a little bit"
#      | form | language             | pronunciation |
#      | 一点儿  | Chinese (Simplified) | yì diǎnr      |
#    Then the group containing "a little bit" should have the following translations:
#      | form         | language             | pronunciation |
#      | un poco de   | Spanish              |               |
#      | a little bit | English              |               |
#      | 一点儿          | Chinese (Simplified) | yì diǎnr      |
#
#  Scenario: a translation can be added mutliple times to the same group
#    Given the following related translations:
#      | form         | language | pronunciation |
#      | a little bit | English  |               |
#    When I add the following translations to the group containing "a little bit"
#      | form | language | pronunciation |
#      | some | English  |               |
#    Then the group containing "a little bit" should have the following translations:
#      | form         | language | pronunciation |
#      | a little bit | English  |               |
#      | some         | English  |               |
#
#  Scenario: ui smoke test
#    When I create a new translation with the following:
#    And I check that the translation appears correctly
#    And I change the translation to the following:
#    And I check that the translation appears correctly
#    And I delete the translation
#    Then there should be no translations in the system
