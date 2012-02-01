Feature: related translations

  Scenario: Create term, link translations in same language by meaning
    When I create the following related terms:
      | form         | language | pronunciation |
      | a little bit | English  |               |
      | some         | English  |               |
    Then the translation "a little bit" is related to translation "some" by meaning
    Then the translation "a little bit" is not related to translation "some" by form
    Then the translation "a little bit" is not related to translation "some" by pronunciation

  Scenario: Difference languages are not linked
    When I create the following related terms:
      | form | language | pronunciation |
      | some | English  | /dɪˈzɜːt/     |
      | some | Spanish  | /dɪˈzɜːt/     |
    Then the translation "some" is not related to translation "some"

  Scenario: Create term, link translations in same language if they share form
    When I create the following related terms:
      | form | language | pronunciation |
      | some | English  |               |
      | some | English  |               |
    Then the translation "some" is related to translation "some" by meaning
    Then the translation "some" is related to translation "some" by form
    Then the translation "some" is not related to translation "some" by pronunciation

  Scenario: Create term, link translations in same language if they share pronunciation
    When I create the following related terms:
      | form         | language | pronunciation |
      | a little bit | English  | /dɪˈzɜːt/     |
      | some         | English  | /dɪˈzɜːt/     |
    Then the translation "a little bit" is related to translation "some" by meaning
    Then the translation "a little bit" is not related to translation "some" by form
    Then the translation "a little bit" is related to translation "some" by pronunciation

  Scenario: Create term, link translations to existing words in same language if they share form
    Given the following related translations:
      | form       | language | pronunciation |
      | to abandon | Spanish  |               |
      | desert     | English  |               |
    When I create the following related terms:
      | form   | language | pronunciation |
      | desert | English  |               |
      | arid   | Spanish  |               |
    Then the translation "desert" is not related to translation "desert" by meaning
    Then the translation "desert" is related to translation "desert" by form
    Then the translation "desert" is not related to translation "desert" by pronunciation

  Scenario: Create term, link translations to existing words in same language if they share pronunciation
    Given the following related translations:
      | form       | language | pronunciation |
      | to abandon | Spanish  |               |
      | desert     | English  | /dɪˈzɜːt/     |
    When I create the following related terms:
      | form      | language | pronunciation |
      | wasteland | English  | /dɪˈzɜːt/     |
      | arid      | Spanish  |               |
    Then the translation "desert" is not related to translation "wasteland" by meaning
    Then the translation "desert" is not related to translation "wasteland" by form
    Then the translation "desert" is related to translation "wasteland" by pronunciation


### TODO: implement these after the cucumber-rails patch is made (currently tested by rspec controller tests)
#
#  Scenario: Add new translation to existing term; link to others in language by meaning
#
#  Scenario: Add new translation to existing term; link to others in language if they share form
#
#  Scenario: Add new translation to existing term; link to others in language if they share pronunciation
#
#  Scenario: update translation, changing language; delink all and relink against new language
#
#  Scenario: update translation, changing form; delink form only and relink
#
#  Scenario: update translation, changing pronunciation; delink pronunciation only and relink