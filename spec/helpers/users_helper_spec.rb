require 'spec_helper'

describe UsersHelper do
  it "returns a Gravatar image tag" do
    user = User.new(name: "Barney Rubble", email: "BRubble@example.com")
    gravatar_for(user).must_equal '<img alt="Barney Rubble" class="gravatar" src="http://gravatar.com/avatar/55dadad828006ab56c23b8e87bdf8aee?s=50" />'
  end
end
