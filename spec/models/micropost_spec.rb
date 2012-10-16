require 'minitest_helper'

describe Micropost do
  before do
    @user = Factory(:user)
    @micropost = @user.microposts.build(content: 'Lorem ipsum dolor sit amet.')
  end

  it "should be a valid object" do
    @micropost.valid?.must_equal true
  end

  it "requires content" do
    @micropost.content = ' '
    @micropost.valid?.wont_equal true
  end

  it "prevents content with more than 140 characters" do
    @micropost.content = 'a' * 141
    @micropost.valid?.wont_equal true
  end

  it "has a user" do
    @micropost.user.must_equal @user
  end
end
