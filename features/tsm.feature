Feature: Tag Space Machine

Background:
  Given there is a new TSM

Scenario: The x stack has only non-instruction literals
  Given the x stack is [«int» 1, «float» 3.8, «bool» false]
  And the ts stack is empty
  When I activate the TSM
  Then the int stack should be [1]
  And the float stack should be [3.8]
  And the bool stack should be [false]