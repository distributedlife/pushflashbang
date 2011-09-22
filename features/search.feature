Feature: search

#  Scenario: search shows no results
#  When my search returns no results
#  Then the I will see no results
#  And the search field will have my search term

#  Scenario: partial match
#  And the following related translations:
#      | form         | language | pronunciation |
#      | un poco de   | Spanish  |               |
#      | a little bit | English  |               |
#  When I search for "poco"
#  Then I will see a result for "un poco de"
#  And I will see a result for "a little bit"

#  Scenario: terms are shown grouped and sorted
#    Given the following related translations:
#      | form         | language             | pronunciation |
#      | un poco de   | Spanish              |               |
#      | a little bit | English              |               |
#      | 一点儿          | Chinese (Simplified) | yì diǎnr      |
#    And the following related translations:
#      | form  | language             | pronunciation |
#      | Hello | English              |               |
#      | 你好    | Chinese (Simplified) | nǐ hǎo        |
#    And the following related translations:
#      | form  | language | pronunciation |
#      | Adios | Spanish  |               |
#    When I view all terms
#    Then all translations are shown grouped and sorted alphabetically by language:
#      | form         | language             | pronunciation |
#      | 一点儿          | Chinese (Simplified) | yì diǎnr      |
#      | a little bit | English              |               |
#      | un poco de   | Spanish              |               |
#      | 你好           | Chinese (Simplified) | nǐ hǎo        |
#      | Hello        | English              |               |
#      | Adios        | Spanish              |               |
