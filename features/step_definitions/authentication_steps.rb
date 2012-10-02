Given /^I am signed in$/ do
  steps %{
    Given there is a user named "John Doe"
    And I am on the signin page
    And I sign in
  }
end

When /^I sign in$/ do
  fill_in "Email", with: @user.email
  fill_in "Password", with: @user.password
  step "I submit the signin form"
end

When /^I sign out$/ do
  click_link "Sign out"
end

Then /^the sign in form is rendered with errors$/ do
  page.must_have_selector "h1", text: "Sign In"
  page.must_have_selector 'div.alert.alert-error'
end

Then /^sign in errors should not persist to next request$/ do
  click_link "Home"
  page.wont_have_selector 'div.alert.alert-error'
end
