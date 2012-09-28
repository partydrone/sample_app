Feature: User pages

  Scenario: Signup page
    Given I am on the signup page
    Then I should see "Sign Up"
    And the title should be "Ruby on Rails Tutorial Sample App | Sign Up"

  Scenario: Profile page
    Given there is a user named "Barney Rubble"
    When I visit his profile page
    Then I should see "Barney Rubble"
    And the title should be "Ruby on Rails Tutorial Sample App | Barney Rubble"

  Scenario: Signup page with invalid info
    Given I am on the signup page
    When I submit a blank form
    Then no user is created
    And the form is rendered with errors

  Scenario: Signup page with valid info
    Given I am on the signup page
    When I sign up
    Then a user is created
    And I'm redirected to the profile page
