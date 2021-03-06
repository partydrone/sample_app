require 'minitest_helper'

describe User do
  before do
    @user = Factory.build(:user)
  end

  it "is a valid object" do
    @user.valid?.must_equal true
  end

  it "requires a name" do
    @user.name = " "
    @user.valid?.wont_equal true
  end

  it "limits a name to 50 characters" do
    @user.name = "a" * 51
    @user.valid?.wont_equal true
  end

  it "requires an email address" do
    @user.email = " "
    @user.valid?.wont_equal true
  end

  it "accepts a valid email address" do
    addresses = %w[user@foo.com THE_USER@mail.example.com first.last@foo.jp a+b@foo.cn a-b@foo.org]
    addresses.each do |valid_email|
      @user.email = valid_email
      @user.valid?.must_equal true
    end
  end

  it "rejects an invalid email address" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
    addresses.each do |invalid_email|
      @user.email = invalid_email
      @user.valid?.wont_equal true
    end
  end

  it "rejects a duplicate email address" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    duplicate_user.save
    @user.valid?.wont_equal true
  end

  it "has a password digest field" do
    @user.must_respond_to :password_digest
  end

  it "has a password field" do
    @user.must_respond_to :password
  end

  it "has a password confirmation field" do
    @user.must_respond_to :password_confirmation
  end

  it "requires a password" do
    @user.password = @user.password_confirmation = " "
    @user.valid?wont_equal true
  end

  it "rejects a nil password confirmation" do
    @user.password_confirmation = nil
    @user.valid?.wont_equal true
  end

  it "requires a minimum of six characters for password" do
    @user.password = @user.password_confirmation = "a" * 5
    @user.valid?.wont_equal true
  end

  it "authenticates a user with valid password" do
    @user.save
    found_user = User.find_by_email(@user.email)
    @user.must_equal found_user.authenticate(@user.password)
  end

  it "doesn't authenticate a user with invalid password" do
    @user.save
    found_user = User.find_by_email(@user.email)
    @user.wont_equal found_user.authenticate("invalid")
  end

  it "returns false for user with invalid password" do
    @user.save
    found_user = User.find_by_email(@user.email)
    found_user.authenticate("invalid").must_equal false
  end

  it "has an authentication token" do
    @user.must_respond_to :auth_token
  end

  it "generates an auth token before saving" do
    @user.save
    found_user = User.find_by_email(@user.email)
    found_user.auth_token.blank?.wont_equal true
  end

  it "has an admin field" do
    @user.must_respond_to :admin
  end

  it "is not an admin by default" do
    @user.admin?.wont_equal true
  end

  it "prevents mass-assignment of admin attribute" do
    proc { User.new(admin: true) }.must_raise ActiveModel::MassAssignmentSecurity::Error
  end

  it "has microposts" do
    @user.must_respond_to :microposts
  end

  it "lists its microposts newest to oldest" do
    @user.save
    old_micropost = Factory(:micropost, user: @user, created_at: 1.day.ago)
    new_micropost = Factory(:micropost, user: @user, created_at: 1.hour.ago)
    @user.microposts.must_equal [new_micropost, old_micropost]
  end

  it "destroys associated microposts" do
    @user.save
    3.times { Factory :micropost, user: @user }
    microposts = @user.microposts
    @user.destroy
    microposts.each do |micropost|
      Micropost.find(micropost).must_be_nil
    end
  end

  it "includes old micropost in feed" do
    @user.save
    old_micropost = Factory(:micropost, user: @user, created_at: 1.day.ago)
    @user.feed.must_include old_micropost
  end

  it "includes new micropost in feed" do
    @user.save
    new_micropost = Factory(:micropost, user: @user, created_at: 1.hour.ago)
    @user.feed.must_include new_micropost
  end

  it "doesn't include unfollowed user microposts" do
    @user.save
    micropost = Factory(:micropost)
    @user.feed.wont_include micropost
  end

  it "includes followed user microposts" do
    @user.save
    unfollowed_post = Factory(:micropost)
    followed_user = Factory(:user)
    @user.follow!(followed_user)
    3.times { followed_user.microposts.create!(content: 'Lorem ipsum dolor sit amet.')}
    followed_user.microposts.each do |micropost|
      @user.feed.must_include micropost
    end
  end

  it "has relationships" do
    @user.must_respond_to :relationships
  end

  it "has users it follows" do
    @user.must_respond_to :followed_users
  end

  it "follows a user" do
    @user.save
    other_user = Factory(:user)
    @user.follow!(other_user).must_be_kind_of Relationship
  end

  it "knows if following a user" do
    @user.save
    other_user = Factory(:user)
    @user.follow!(other_user)
    @user.following?(other_user).must_equal true
    # Included as part of following tutorial, but either unnecessary or should be in own test
    @user.followed_users.must_include other_user
  end

  it "unfollows a user" do
    @user.save
    other_user = Factory(:user)
    @user.follow!(other_user)
    @user.unfollow!(other_user)
    @user.following?(other_user).wont_equal true
    # Included as part of following tutorial, but either unnecessary or should be in own test
    @user.followed_users.wont_include other_user
  end

  it "has reverse relationships" do
    @user.must_respond_to :reverse_relationships
  end

  it "has users that follow it" do
    @user.save
    other_user = Factory(:user)
    other_user.follow!(@user)
    @user.followers.must_include other_user
  end
end
