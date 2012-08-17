Feature: Pizza

  Background:
    Given I have a new pizza

  Scenario: pizza slicing
    Given a list of slice sizes [1,0,7,9,3,12,33,0,0,0,2.88,2.12]
    When I slice the pizza
    Then there should be 12 slices
    And the pizza should weigh 70
    And the pizza should be whole
  
  Scenario: eating the first slice unfolds the circle
    Given the pizza is sliced into [1,2,3,4,5,6,7,8]
    And no pieces have been eaten
    When I take out piece 6
    Then the pizza should not be whole
    And the left slice should weigh 7
    And the right slice should weigh 5
  
  Scenario: you can eat the left or right pieces only
  
  
  