Given /^I am on the (.*?) page$/ do |text|
  if text == 'home'
    visit root_path
  else
    eval "visit #{text}_path"
  end
end

Then /^the heading should be "(.*?)"$/ do |text|
  page.must_have_selector 'h1', text: text
end

Then /^the title should be "(.*?)"$/ do |text|
  page.must_have_selector 'title', text: text
end

Then /^there should be a "(.*?)" link to the (.*?) page$/ do |text, path|
  if path =~ /(.*?)'s$/
    page.must_have_link text, href: eval("#{$1}_path(@#{$1})")
  else
    page.must_have_link text, href: eval("#{path}_path")
  end
end

Then /^there should not be a "(.*?)" link to the (.*?) page$/ do |text, path|
  page.wont_have_link text, href: eval("#{path}_path")
end
