Feature: User pages

  Scenario: Signup page
    Given I am on the signup page
    Then the heading should be "Sign Up"
      And the title should be "Ruby on Rails Tutorial Sample App | Sign Up"

  Scenario: Profile page
    Given there is a user named "Barney Rubble"
    When I visit his profile page
    Then the heading should be "Barney Rubble"
      And the title should be "Ruby on Rails Tutorial Sample App | Barney Rubble"

  Scenario: Sign up with invalid info
    Given I am on the signup page
      And I submit a blank signup form
    Then no user is created
      And the signup form is rendered with errors

  Scenario: Sign up with valid info
    Given I am on the signup page
    When I sign up
    Then a user is created
      And I'm redirected to the profile page
      And there should be a "Sign out" link to the signout page
      And there should not be a "Sign in" link to the signin page
