Feature: language decks
  As a language learner
  I want to organise my items to learn in a deck
  So that I can focus on particular areas

  Background: 
    Given I am a new, authenticated user

  Scenario: user can create a deck
    Given I am on the create deck page
    When I create a deck
    Then I should be redirected to the show deck page

  Scenario: user cannot see deck created by other user
    Given a deck created by another user
    When I go to the show deck page
    Then I should be redirected to the user home page

  Scenario: user can see  shared deck created by other user
    Given a deck created by another user that is shared
    When I go to the show deck page
    Then I should see "shared"
    
  Scenario: user can edit deck
    Given I have created a deck
    And I am on the edit deck page
    And I edit all deck properties
    When I press "Save Changes"
    Then I am redirected to the show deck page
    And the deck should be updated

  Scenario: user can't edit a deck into an invalid state
    Given I have created a deck
    And I am on the edit deck page
    And I edit all deck properties to be invalid
    When I press "Save Changes"
    Then the deck is not updated
    And I should be on the edit deck page

  Scenario: user can't edit deck created by other user
    Given a deck created by another user
    When I go to the edit deck page
    Then I should be redirected to the user home page

  Scenario: user can delete a created deck
    Given I have created a deck
    And I am on the edit deck page
    When I click on "Delete Deck"
    Then the deck should be deleted
    Then I should be redirected to the user home page

  Scenario: user can see decks they have created
    Given I have created a deck
    And I go to the user home page
    Then I can see all of my decks

  Scenario: user can edit deck from view deck page
    Given I have created a deck
    And I am on the show deck page
    When I click on "Edit Deck"
    Then I should be redirected to the edit deck page

  Scenario: user cannot see deck created by other user
    Given a deck created by another user
    And I go to the user home page
    Then I will not see decks created by other users

  Scenario: user can see deck shared by other user
    Given a deck created by another user that is shared
    And I go to the user home page
    Then I will see shared decks created by other users

  Scenario: user can share their own deck
    Given I have created a deck
    And I am on the show deck page
    When I click on "Share Deck"
    Then the deck will be shared

  Scenario: user can unshare their own deck
    Given I have created a shared deck
    And I am on the show deck page
    When I click on "Stop Sharing Deck"
    Then the deck will no longer be shared

  Scenario: user can see if deck is shared on home page
    Given I have created a shared deck
    And I go to the user home page
    Then I should see "shared"

  Scenario: user can see if deck is shared on deck page
    Given I have created a shared deck
    When I am on the show deck page
    Then I should see "shared"

  Scenario: user home page shows card count
    Given I have created a deck
    And I have created multiple cards
    When I go to the user home page
    Then I should see the card count

  Scenario: deck home page shows due cards count
    Given I have created a deck
    And I have created multiple cards
    And there are cards due
    When I go to the user home page
    Then I should see the card due count

#  Scenario: user can clone deck created by another person
#    Given a deck created by another user that is shared
#    And I am on the view deck page
#    When I click "Clone deck"
#    Then the deck should be cloned
#    And I should be on the view deck page for the new deck