require 'minitest_helper'

describe Relationship do
  before do
    @followed = Factory(:user)
    @follower = Factory(:user)
    @relationship = @follower.relationships.new(followed_id: @followed.id)
  end

  it "is a valid object" do
    @relationship.valid?.must_equal true
  end

  it "prevents mass-assignment of follower_id" do
    proc { Relationship.new(follower_id: @follower_id) }.must_raise ActiveModel::MassAssignmentSecurity::Error
  end

  it "returns followed user" do
    @relationship.followed.must_equal @followed
  end

  it "returns follower user" do
    @relationship.follower.must_equal @follower
  end

  it "requires a followed id" do
    @relationship.followed_id = nil
    @relationship.valid?.wont_equal true
  end

  it "requires a follower id" do
    @relationship.follower_id = nil
    @relationship.valid?.wont_equal true
  end
end
