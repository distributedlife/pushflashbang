Feature:
  In order to reduce the maintability of learnable words
  As a content creator
  I want words to be made available to everyone

  Scenario: Created cards can be seen by all users
  Given there exists created by other users
  When I go to the cards page
  Then I can see all 