Given /^there is a user named "(.*?)"$/ do |name|
  @user = Factory(:user, name: name)
end

When /^I visit his profile page$/ do
  visit user_path(@user)
end

Then /^no user is created$/ do
  User.count.must_equal @count
end

Then /^the signup form is rendered with errors$/ do
  page.must_have_selector "h1", text: "Sign Up"
  page.must_have_content "error"
  page.wont_have_content "Password digest"
end

When /^I sign up$/ do
  fill_in "Name", with: "Barney Rubble"
  fill_in "Email", with: "brubble@example.com"
  fill_in "Password", with: "foobar"
  fill_in "Confirmation", with: "foobar"
  step "I submit the signup form"
end

Then /^a user is created$/ do
  User.count.must_equal @count + 1
end

Then /^I'm redirected to the profile page$/ do
  steps %{
     Then the heading should be "Barney Rubble"
     And the title should be "Ruby on Rails Tutorial Sample App | Barney Rubble"
  }
  page.must_have_selector 'div.alert.alert-success'
end
