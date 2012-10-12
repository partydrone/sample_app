require 'minitest_helper'

describe "Microposts integration" do
  before do
    @user = Factory(:user)
    sign_in @user
  end

  describe "micropost creation" do
    before do
      visit root_path
    end

    describe "with valid info" do
      
    end

    describe "with invalid info" do
      it "won't create a micropost" do
        count = Micropost.count
        click_button 'Post'
        Micropost.count.must_equal count
      end

      it "displays an error message" do
        click_button 'Post'
        page.must_have_content 'error'
      end
    end
  end

  describe "micropost destruction" do
    it "deletes a user's micropost" do
      micropost = Factory(:micropost, user: @user)
      count = Micropost.count
      visit root_path
      click_link 'delete'
      Micropost.count.must_equal count - 1
    end
  end
end
