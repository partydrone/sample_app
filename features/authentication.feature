Feature: Authentication

  Scenario: Sign in page
    Given I am on the signin page
    Then the heading should be "Sign In"
      And the title should be "Ruby on Rails Tutorial Sample App | Sign In"

  Scenario: Sign in with invalid info
    Given I am on the signin page
      And I submit a blank signin form
    Then the sign in form is rendered with errors
      And sign in errors should not persist to next request

  Scenario: Sign in with valid info
    Given there is a user named "John Doe"
      And I am on the signin page
    When I sign in
    Then the heading should be "John Doe"
      And there should be a "Profile" link to the user's page
      And there should be a "Sign out" link to the signout page
      And there should not be a "Sign in" link to the signin page

  Scenario: Sign out
    Given I am signed in
    When I sign out
    Then there should be a "Sign in" link to the signin page
      And there should not be a "Sign out" link to the signout page
