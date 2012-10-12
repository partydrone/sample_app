require 'minitest_helper'

describe MicropostsController do
  it "requires authenticated user to create" do
    post :create
    response.status.must_equal 302
    response.header['Location'].must_match signin_path
  end

  it "requires authenticated user to delete" do
    delete :destroy, id: Factory(:micropost)
    response.status.must_equal 302
    response.header['Location'].must_match signin_path
  end
end
