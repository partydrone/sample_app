Given /^I am on the (.*?) page$/ do |text|
  if text == 'home'
    visit root_path
  else
    eval("visit #{text}_path")
  end
end

Then /^I should see "(.*?)"$/ do |text|
  page.must_have_selector('h1', text: text)
end

Then /^the title should be "(.*?)"$/ do |text|
  page.must_have_selector('title', text: text)
end
