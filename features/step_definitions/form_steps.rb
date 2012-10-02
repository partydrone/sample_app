When /^I submit (?:the|a blank) (.*?) form$/ do |text|
  case text
  when "signup"
    @count = User.count
    click_button "Create my account"
  when "signin"
    click_button "Sign in"
  end
end
