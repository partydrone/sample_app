Given /^there is a user named "(.*?)"$/ do |name|
  @user = User.create(name: name, email: "user@example.com", password: "password", password_confirmation: "password")
end

When /^I visit his profile page$/ do
  visit user_path(@user)
end

When /^I submit (?:the|a blank) form$/ do
  @count = User.count
  click_button "Create my account"
end

Then /^no user is created$/ do
  User.count.must_equal @count
end

Then /^the form is rendered with errors$/ do
  page.must_have_selector "h1", text: "Sign Up"
  page.must_have_content "error"
  page.wont_have_content "Password digest"
end

When /^I sign up$/ do
  fill_in "Name", with: "Barney Rubble"
  fill_in "Email", with: "brubble@example.com"
  fill_in "Password", with: "foobar"
  fill_in "Confirmation", with: "foobar"
  step "I submit the form"
end

Then /^a user is created$/ do
  User.count.must_equal @count + 1
end

Then /^I'm redirected to the profile page$/ do
  steps %{
     Then I should see "Barney Rubble"
     And the title should be "Ruby on Rails Tutorial Sample App | Barney Rubble"
  }
  page.must_have_selector 'div.alert.alert-success', text: "Welcome"
end
