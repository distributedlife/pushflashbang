@javascript
Feature: reviewing related translations

  Background:
    Given reference data has been loaded
    And the following sets:
      | name      | description                                    |
      | all |  |
    And the user has the "all" set as a goal for the "Chinese" language
    And the user native language is "English"

  Scenario: Listening review, share pronunciation (learned)
    Given the following related translations:
      | form | language | pronunciation |
      | he | English  | |
      | 他1    | Chinese | ta              |
    And the following related translations:
      | form | language | pronunciation |
      | she | English  | |
      | 她2    | Chinese | ta              |
    And the following related translations:
      | form | language | pronunciation |
      | it | English  | |
      | 它3    | Chinese | ta              |
    And the group containing "he" is in the set "all"
    And the group containing "she" is in the set "all"
    And the group containing "it" is in the set "all"
    And the user has reviewed the idiom "he" before in the "Chinese" language
    And the user has reviewed the idiom "she" before in the "Chinese" language
    And the user has reviewed the idiom "it" before in the "Chinese" language
    When I review the "he" term in the "all" set in "Chinese" using the "listening" review mode
    Then before the reveal I should see "3" meanings
    And after the reveal I should see native text containing "he"
    And after the reveal I should see native text containing "she"
    And after the reveal I should see native text containing "it"
    And after the reveal I should see learned text containing "他"
    And after the reveal I should see learned text containing "她"
    And after the reveal I should see learned text containing "它"

  Scenario: share pronunciation (native)
    Given the following related translations:
      | form | language | pronunciation |
      | he | Chinese  | |
      | 他1    | English | ta              |
    And the following related translations:
      | form | language | pronunciation |
      | she | Chinese  | |
      | 她2    | English| ta              |
    And the group containing "he" is in the set "all"
    And the group containing "she" is in the set "all"
    And the user has reviewed the idiom "he" before in the "Chinese" language
    And the user has reviewed the idiom "she" before in the "Chinese" language
    When I review the "he" term in the "all" set in "Chinese" using the "listening" review mode
    Then before the reveal I should see "1" meanings
    And after the reveal I should see learned text containing "he"
    And after the reveal I should see native text containing "他"

  Scenario: Translation review, share meaning (both)
    Given the following related translations:
      | form | language | pronunciation |
      | hi | English  | |
      | hello | English  | |
      | 你好    | Chinese | ni hao              |
      | 喂    | Chinese | wei              |
    And the group containing "hi" is in the set "all"
    And the user has reviewed the idiom "hi" before in the "Chinese" language
    When I review the "hi" term in the "all" set in "Chinese" using the "translating" review mode
    Then before the reveal I should see "2" meanings
    And before the reveal I should see native text containing "hi"
    And before the reveal I should see native text containing "hello"
    And after the reveal I should see learned text containing "你好"
    And after the reveal I should see learned text containing "喂"

  Scenario: Reading review, share form and proncunciation (learned)
    Given the following related translations:
      | form | language | pronunciation |
      | fur | English  | fur|
      | 毛 | Chinese  | mao2 |
    And the following related translations:
      | form | language | pronunciation |
      | hair | English  | hair|
      | 毛 | Chinese  | mao2 |
      | 牦 | Chinese  | mao2 |
    And the following related translations:
      | form | language | pronunciation |
      | feathers | English  | feathers|
      | 毛 | Chinese  | mao2 |
    And the following related translations:
      | form | language | pronunciation |
      | tail | English  | rail|
      | 牦 | Chinese  | mao2 |
    And the following related translations:
      | form | language | pronunciation |
      | yak | English  | yak|
      | 牦 | Chinese  | mao2 |
    And the group containing "fur" is in the set "all"
    And the group containing "hair" is in the set "all"
    And the group containing "feathers" is in the set "all"
    And the group containing "tail" is in the set "all"
    And the group containing "yak" is in the set "all"
    And the user has reviewed the idiom "fur" before in the "Chinese" language
    And the user has reviewed the idiom "hair" before in the "Chinese" language
    And the user has reviewed the idiom "feathers" before in the "Chinese" language
    And the user has reviewed the idiom "tail" before in the "Chinese" language
    And the user has reviewed the idiom "yak" before in the "Chinese" language
    When I review the "fur" term in the "all" set in "Chinese" using the "reading" review mode
    Then before the reveal I should see "3" meanings
    And before the reveal I should see learned text containing "毛"
    And after the reveal I should see native text containing "fur"
    And after the reveal I should see native text containing "feathers"
    And after the reveal I should see native text containing "hair"

  Scenario: Reading review, share form and proncunciation (learned)
    Given the following related translations:
      | form | language | pronunciation |
      | fur | Chinese  | fur|
      | 毛 | English | mao2 |
    And the following related translations:
      | form | language | pronunciation |
      | hair | Chinese  | hair|
      | 毛 | English  | mao2 |
      | 牦 | English  | mao2 |
    And the following related translations:
      | form | language | pronunciation |
      | feathers | Chinese  | feathers|
      | 毛 |English  | mao2 |
    And the following related translations:
      | form | language | pronunciation |
      | tail | Chinese  | rail|
      | 牦 | English  | mao2 |
    And the following related translations:
      | form | language | pronunciation |
      | yak | Chinese | yak|
      | 牦 | English  | mao2 |
    And the group containing "fur" is in the set "all"
    And the group containing "hair" is in the set "all"
    And the group containing "feathers" is in the set "all"
    And the group containing "tail" is in the set "all"
    And the group containing "yak" is in the set "all"
    And the user has reviewed the idiom "fur" before in the "Chinese" language
    And the user has reviewed the idiom "hair" before in the "Chinese" language
    And the user has reviewed the idiom "feathers" before in the "Chinese" language
    And the user has reviewed the idiom "tail" before in the "Chinese" language
    And the user has reviewed the idiom "yak" before in the "Chinese" language
    When I review the "fur" term in the "all" set in "Chinese" using the "reading" review mode
    Then before the reveal I should see "1" meanings
    And before the reveal I should see learned text containing "fur"
    And after the reveal I should see native text containing "毛"


  Scenario: Share proncunciation and meaning (learned)
    Given the following related translations:
      | form | language | pronunciation |
      | hair | English  | hair|
      | 毛 | Chinese  | mao |
      | 牦 | Chinese  | mao |
    And the group containing "hair" is in the set "all"
    And the user has reviewed the idiom "hair" before in the "Chinese" language
    When I review the "hair" term in the "all" set in "Chinese" using the "listening" review mode
    Then before the reveal I should see "2" meaning
    And after the reveal I should see learned text containing "毛"
    And after the reveal I should see learned text containing "牦"
    And after the reveal I should see native text containing "hair"

  Scenario: Share proncunciation and meaning (native)
    Given the following related translations:
      | form | language | pronunciation |
      | hair | Chinese  | hair|
      | 毛 | English  | mao |
      | 牦 | English  | mao |
    And the group containing "hair" is in the set "all"
    And the user has reviewed the idiom "hair" before in the "Chinese" language
    When I review the "hair" term in the "all" set in "Chinese" using the "listening" review mode
    Then before the reveal I should see "1" meaning
    And after the reveal I should see learned text containing "hair"
    And after the reveal I should see native text containing "毛"
    And after the reveal I should see native text containing "牦"

  Scenario: Share form (learned)
    Given the following related translations:
      | form | language | pronunciation |
      | desert | English  | desert|
      | 毛 | Chinese  | sdfs |
    And the following related translations:
      | form | language | pronunciation |
      | desert | English  | desert|
      | 牦 | Chinese  | nleg|
    And the group containing "毛" is in the set "all"
    And the group containing "牦" is in the set "all"
    And the user has reviewed the idiom "毛" before in the "Chinese" language
    And the user has reviewed the idiom "牦" before in the "Chinese" language
    When I review the "毛" term in the "all" set in "Chinese" using the "listening" review mode
    Then before the reveal I should see "1" meaning
    And after the reveal I should see native text containing "desert"
    And after the reveal I should see learned text containing "毛"

  Scenario: Share form (native)
    Given the following related translations:
      | form | language | pronunciation |
      | desert | Chinese  | desert|
      | 毛 | English  | sdfs |
    And the following related translations:
      | form | language | pronunciation |
      | desert | Chinese| desert|
      | 牦 | English  | nleg|
    And the group containing "毛" is in the set "all"
    And the group containing "牦" is in the set "all"
    And the user has reviewed the idiom "毛" before in the "Chinese" language
    And the user has reviewed the idiom "牦" before in the "Chinese" language
    When I review the "毛" term in the "all" set in "Chinese" using the "listening" review mode
    Then before the reveal I should see "2" meanings
    And after the reveal I should see learned text containing "desert"
    And after the reveal I should see native text containing "毛"
    And after the reveal I should see native text containing "牦"

  Scenario: Share form and meaning (native)
    Given the following related translations:
      | form | language | pronunciation |
      | gasses | English  | desert|
      | gases | English  | desert|
      | 毛 | Chinese  | sdfs |
    And the group containing "毛" is in the set "all"
    And the user has reviewed the idiom "毛" before in the "Chinese" language
    When I review the "毛" term in the "all" set in "Chinese" using the "listening" review mode
    Then before the reveal I should see "1" meanings
    And after the reveal I should see native text containing "gasses"
    And after the reveal I should see native text containing "gases"
    And after the reveal I should see learned text containing "毛"

  Scenario: Share form and meaning (learned)
    Given the following related translations:
      | form | language | pronunciation |
      | gasses | Chinese  | desert|
      | gases | Chinese  | desert|
      | 毛 | English  | sdfs |
    And the group containing "毛" is in the set "all"
    And the user has reviewed the idiom "毛" before in the "Chinese" language
    When I review the "毛" term in the "all" set in "Chinese" using the "listening" review mode
    Then before the reveal I should see "2" meaning
    And after the reveal I should see learned text containing "gasses"
    And after the reveal I should see learned text containing "gases"
    And after the reveal I should see native text containing "毛"


  Scenario: ignore other languages
    Given the following related translations:
      | form | language | pronunciation |
      | el gasisos | Spanish  | desert|
      | gases | English | desert|
      | 毛 | Chinese  | sdfs |
    And the group containing "毛" is in the set "all"
    And the user has reviewed the idiom "毛" before in the "Chinese" language
    When I review the "毛" term in the "all" set in "Chinese" using the "listening" review mode
    Then before the reveal I should see "1" meaning
    And after the reveal I should see native text containing "gases"
    And after the reveal I should see learned text containing "毛"


  Scenario: do not show idioms not yet learned by the user
    Given the following related translations:
      | form | language | pronunciation |
      | desert | Chinese  | desert|
      | 毛 | English  | sdfs |
    And the following related translations:
      | form | language | pronunciation |
      | desert | Chinese| desert|
      | 牦 | English  | nleg|
    And the group containing "毛" is in the set "all"
    And the group containing "牦" is in the set "all"
    And the user has reviewed the idiom "毛" before in the "Chinese" language
    When I review the "毛" term in the "all" set in "Chinese" using the "listening" review mode
    Then before the reveal I should see "1" meanings
    And after the reveal I should see learned text containing "desert"
    And after the reveal I should see native text containing "毛"
    And after the reveal I should not see native text containing "牦"


  Scenario: do not record reviews against idioms not yet learned by the user
    Given the following related translations:
      | form | language | pronunciation |
      | desert | Chinese  | desert|
      | 毛 | English  | sdfs |
    And the following related translations:
      | form | language | pronunciation |
      | desert | Chinese| desert|
      | 牦 | English  | nleg|
    And the group containing "毛" is in the set "all"
    And the group containing "牦" is in the set "all" in chapter "2"
    And the user has reviewed the idiom "毛" before in the "Chinese" language
    When I record the successful review of the "毛" term in the "all" set in "Chinese" using the "listening" review mode
    Then the "毛" term should have a review and be scheduled in the future for "listening"
    And the "牦" term should not have a review and should not be scheduled for "listening"

 Scenario: do not record reviews against idioms not yet learned by the user
    Given the following related translations:
      | form | language | pronunciation |
      | desert | Chinese  | desert|
      | 毛 | English  | sdfs |
    And the following related translations:
      | form | language | pronunciation |
      | desert | Chinese| desert|
      | 牦 | English  | nleg|
    And the group containing "毛" is in the set "all"
    And the group containing "牦" is in the set "all"
    And the user has reviewed the idiom "毛" before in the "Chinese" language
    And the user has reviewed the idiom "牦" before in the "Chinese" language
    When I record the successful review of the "毛" term in the "all" set in "Chinese" using the "listening" review mode
    Then the "毛" term should have a review and be scheduled in the future for "listening"
    Then the "牦" term should have a review and be scheduled in the future for "listening"
    And the terms "毛", "牦" should be in sync for "listening"