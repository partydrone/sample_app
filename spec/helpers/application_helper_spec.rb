require 'spec_helper'

describe ApplicationHelper do
  it "formats a full title when an argument is given" do
    full_title("Contact").must_equal "Ruby on Rails Tutorial Sample App | Contact"
  end

  it "returns the base title when no argument is given" do
    full_title(nil).must_equal "Ruby on Rails Tutorial Sample App"
  end
end
