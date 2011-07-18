Feature: users can add new terms to the system
  In order to increase the terms to learn for users
  As someone who is fluent in a language
  I want to be able to add a terms to the system

  @user
  Scenario: add a term
    When I create the following related terms:
      | form         | language | pronunciation |
      | un poco de   | Spanish  |               |
      | a little bit | English  |               |
    # this line is commented out as the akephalos driver tries to use a html template and not a haml one
    #      | 一点儿          | Chinese (Simplified) | yì diǎnr      |
    Then translations will all linked to the same idiom
    And I should see "Related terms created"

  @user
  Scenario: an invalid term allows the user to make corrections
    When I create the following related terms:
      | form         | language | pronunciation |
      | un poco de   | Spanish  |               |
      | a little bit |          |               |
    Then I should be on the "Add term" page
    And I should see the following in the form:
      | form         | language | pronunciation |
      | un poco de   | Spanish  |               |
      | a little bit |          |               |

  @user
  Scenario: view term
    Given the following related translations:
      | form         | language             | pronunciation |
      | un poco de   | Spanish              |               |
      | a little bit | English              |               |
      | 一点儿          | Chinese (Simplified) | yì diǎnr      |
    When I view the following translations to the group containing "a little bit"
    Then all translations are shown grouped and sorted alphabetically by language:
      | form         | language             | pronunciation |
      | 一点儿          | Chinese (Simplified) | yì diǎnr      |
      | a little bit | English              |               |
      | un poco de   | Spanish              |               |

  @user
  Scenario: edit a translation
    Given the following related translations:
      | form         | language             | pronunciation |
      | un poco de   | Spanish              |               |
      | a little bit | English              |               |
      | 一点儿          | Chinese (Simplified) | yì diǎnr      |
    When I edit the translation "a little bit" to "some"
    Then the group containing "some" should have the following translations:
      | form       | language             | pronunciation |
      | un poco de | Spanish              |               |
      | some       | English              |               |
      | 一点儿        | Chinese (Simplified) | yì diǎnr      |

  #currently wip'd because the javascript driver can't handle .js.haml page templates
  @wip
  Scenario: attach translation to an idiom
    Given the following related translations:
      | form         | language | pronunciation |
      | un poco de   | Spanish  |               |
      | a little bit | English  |               |
    When I attach the following translations to the group containing "a little bit"
      | form | language             | pronunciation |
      | 一点儿  | Chinese (Simplified) | yì diǎnr      |
    Then the group containing "a little bit" should have the following translations:
      | form         | language             | pronunciation |
      | un poco de   | Spanish              |               |
      | a little bit | English              |               |
      | 一点儿          | Chinese (Simplified) | yì diǎnr      |

  @user
  Scenario: terms are shown grouped and sorted
    Given the following related translations:
      | form         | language             | pronunciation |
      | un poco de   | Spanish              |               |
      | a little bit | English              |               |
      | 一点儿          | Chinese (Simplified) | yì diǎnr      |
    And the following related translations:
      | form  | language             | pronunciation |
      | Hello | English              |               |
      | 你好    | Chinese (Simplified) | nǐ hǎo        |
    And the following related translations:
      | form  | language | pronunciation |
      | Adios | Spanish  |               |
    When I view all terms
    Then all translations are shown grouped and sorted alphabetically by language:
      | form         | language             | pronunciation |
      | 一点儿          | Chinese (Simplified) | yì diǎnr      |
      | a little bit | English              |               |
      | un poco de   | Spanish              |               |
      | 你好           | Chinese (Simplified) | nǐ hǎo        |
      | Hello        | English              |               |
      | Adios        | Spanish              |               |

  @user
  Scenario Outline: user can't delete a term from an idiom if there are only two left
    Given a term with <translation count> translations
    When I delete a translation
    Then the term will have <after delete count> translations

    Examples:
      | translation count | after delete count |
      | 2                 | 2                  |
      | 3                 | 2                  |

  @user
  Scenario: detach translation from current idiom and attach to new
    Given the following related translations:
      | form         | language             | pronunciation |
      | a little bit | English              |               |
      | un poco de   | Spanish              |               |
      | 一点儿          | Chinese (Simplified) | yì diǎnr      |
    And the following related translations:
      | form  | language             | pronunciation |
      | Hello | English              |               |
      | 你好    | Chinese (Simplified) | nǐ hǎo        |
    When I move "a little bit" to the group containing "Hello"
    Then the group containing "a little bit" should have the following translations:
      | form         | language             | pronunciation |
      | Hello        | English              |               |
      | a little bit | English              |               |
      | 你好           | Chinese (Simplified) | nǐ hǎo        |
    And the group containing "un poco de" should have the following translations:
      | form       | language             | pronunciation |
      | un poco de   | Spanish              |               |
      | 一点儿        | Chinese (Simplified) | yì diǎnr      |

  @user
  Scenario: user can attach an existing term to multiple idioms
    Given the following related translations:
      | form         | language             | pronunciation |
      | un poco de   | Spanish              |               |
      | a little bit | English              |               |
      | 一点儿          | Chinese (Simplified) | yì diǎnr      |
    And the following related translations:
      | form  | language             | pronunciation |
      | Hello | English              |               |
      | 你好    | Chinese (Simplified) | nǐ hǎo        |
    When I attach "a little bit" to the group containing "Hello"
    Then the group containing "Hello" should have the following translations:
      | form         | language             | pronunciation |
      | a little bit | English              |               |
      | Hello        | English              |               |
      | 你好           | Chinese (Simplified) | nǐ hǎo        |
    And the group containing "un poco de" should have the following translations:
      | form         | language             | pronunciation |
      | a little bit | English              |               |
      | un poco de   | Spanish              |               |
      | 一点儿          | Chinese (Simplified) | yì diǎnr      |

  @user
  Scenario: attach translation to new idiom and detach from old
    Given the following related translations:
      | form         | language             | pronunciation |
      | un poco de   | Spanish              |               |
      | a little bit | English              |               |
      | 一点儿          | Chinese (Simplified) | yì diǎnr      |
    And the following related translations:
      | form  | language             | pronunciation |
      | Hello | English              |               |
      | 你好    | Chinese (Simplified) | nǐ hǎo        |
    When I attach and remove "a little bit" to the group containing "Hello"
    Then the group containing "Hello" should have the following translations:
      | form         | language             | pronunciation |
      | a little bit | English              |               |
      | Hello        | English              |               |
      | 你好           | Chinese (Simplified) | nǐ hǎo        |
    And the group containing "un poco de" should have the following translations:
      | form       | language             | pronunciation |
      | un poco de | Spanish              |               |
      | 一点儿        | Chinese (Simplified) | yì diǎnr      |

  