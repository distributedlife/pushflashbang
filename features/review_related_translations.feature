Feature: reviewing related translations

  Background:
    Given reference data has been loaded
    And the following related translations:
      | form | language | pronunciation |
      | two  | English  | /dɪˈzɜː(ɹ)t/  |
      | 2    | English  |               |
      | 二    | Chinese  | èr            |
      | 两    | Chinese  | liǎng         |
      | dos  | Spanish  |               |
    And the following related translations:
      | form        | language | pronunciation |
      | desert      | English  | /dɪˈzɜː(ɹ)t/  |
      | arid region | English  |               |
      | 沙漠          | Chinese  | tián shí      |
      | desertes    | Spanish  |               |
    And the following related translations:
      | form             | language | pronunciation |
      | desert           | English  | /dɪˈzɜːt/     |
      | 沙                | Chinese  | ce dee        |
      | justice desertes | Spanish  |               |
    And the following related translations:
      | form    | language | pronunciation |
      | dessert | English  | /dɪˈzɜːt/     |
      | 甜食      | Chinese  | tián shí      |
      | curros  | Spanish  |               |
    And the group containing "two" is in the set "numbers"
    And the group containing "arid region" is in the set "all"
    And the group containing "抛弃" is in the set "all" in chapter "2"
    And the group containing "dessert" is in the set "all" in chapter "3"
    And the user has the "all" set as a goal for the "English" language
    And the user has the "numbers" set as a goal for the "English" language
    And the user native language is "Chinese"

  #three idioms with multiple relationships
  #Learned-Meaning: desert, arid region
  #Native-Meaning:  沙漠
  #Learned-Written: desert, desert
  #Native-Written:
  #Learned-Audible: desert, desserts
  #Native-Audible: 甜食, 沙漠


  Scenario: user reviews term with relationship to itself via meaning (both native and learned)
    When I review the "two" term in the "numbers" set in "English" using the "translating" review mode
    Then before the reveal I should see "二"
    And before the reveal I should see "两"
    And before the reveal I should see "2 meanings"
    And after the reveal I should see "one"
    And after the reveal I should see "1"
    And I should not see "dos"

  Scenario: review term with relationship to another by written, relationship not yet known
    When I review the "arid region" term in the "all" set in "English" using the "reading" review mode
    Then before the reveal I should see "desert"
    And before the reveal I should see "arid region"
    And before the reveal I should see "1 meaning"
    And after the reveal I should see "沙漠"

  Scenario: review term with relationship to another by written, relationship is now known
    Given I have reviewed the term containing "沙漠" in "English" using the "reading" review mode
    When I review the "arid region" term in the "all" set in "English" using the "reading" review mode
    Then before the reveal I should see "desert"
    And before the reveal I should see "arid region"
    And before the reveal I should see "2 meanings"
    And after the reveal I should see "沙漠"
    And after the reveal I should see "沙"

  Scenario: review term with relationship to another by audible form, relationship not yet known
    When I review the "沙" term in the "all" set in "English" using the "listening" review mode
    And before the reveal I should see "1 meaning"
    And after the reveal I should see "desert"

  Scenario: review term with relationship to another by audible form, relationship is now known
    Given I have reviewed the term containing "沙" in "English" using the "listening" review mode
    When I review the "dessert" term in the "all" set in "English" using the "listening" review mode
    And before the reveal I should see "2 meaning"
    And after the reveal I should see "desert"
    And after the reveal I should see "dessert"

  Scenario: recording a review when I know no other cards
    When I review the "沙" term in the "all" set in "English" using the "listening" review mode
    And I record the review as a success
    Then the "沙" term should have a review and be scheduled
    And the "dessert" term should not have a review and should not be scheduled

  Scenario: recording a review when I know other cards that share something
    Given I have reviewed the term containing "沙" in "English" using the "listening" review mode
    When I review the "dessert" term in the "all" set in "English" using the "listening" review mode
    And I record the review as a success
    Then the "沙" term should have a review and be scheduled
    Then the "dessert" term should have a review and be scheduled
    And the "沙" term and the "dessert" term schedule should be in sync for "listening"