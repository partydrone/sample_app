require 'minitest_helper'

describe UsersController do
  it "requires authenticated user to update" do
    post :update, id: Factory(:user)
    response.status.must_equal 302
    response.header['Location'].must_match %r(#{signin_path}$)
  end

  it "requires authorized user to update" do
    user = Factory(:user)
    wrong_user = Factory(:user, email: 'wrong@example.com')
    cookies[:auth_token] = user.auth_token
    post :update, id: wrong_user
    response.status.must_equal 302
    response.header['Location'].must_match %r(#{root_path}$)
  end

  it "requires authenticated user to delete" do
    delete :destroy, id: Factory(:user)
    response.status.must_equal 302
    response.header['Location'].must_match signin_path
  end

  it "requires admin to delete" do
    user = Factory(:user)
    cookies[:auth_token] = user.auth_token
    delete :destroy, id: user
    response.status.must_equal 302
    response.header['Location'].must_match %r(#{root_path}$)
  end
end
