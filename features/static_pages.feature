Feature: Static Pages

  Scenario: Home page
    Given I am on the home page
    Then I should see "Sample App"
    And the title should be "Ruby on Rails Tutorial Sample App"

  Scenario: Help page
    Given I am on the help page
    Then I should see "Help"
    And the title should be "Ruby on Rails Tutorial Sample App | Help"

  Scenario: About page
    Given I am on the about page
    Then I should see "About Us"
    And the title should be "Ruby on Rails Tutorial Sample App | About Us"

  Scenario: Contact page
    Given I am on the contact page
    Then I should see "Contact Us"
    And the title should be "Ruby on Rails Tutorial Sample App | Contact Us"
    