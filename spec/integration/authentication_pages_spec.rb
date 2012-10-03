require 'spec_helper'

describe "Authentication pages integration" do
  describe "sign in" do
    
    before do
      visit signin_path
    end

    it "displays 'Sign in' in the header" do
      page.must_have_selector "h1", text: "Sign In"
    end

    it "displays 'Sign in' in the title" do
      page.must_have_selector "title", text: "Sign In"
    end

    describe "with valid information" do
      before do
        @user = Factory(:user)
        fill_in "Email", with: @user.email
        fill_in "Password", with: @user.password
        click_button "Sign in"
      end

      it "displays the user's name" do
        page.must_have_selector "h1", text: @user.name
      end

      it "displays a profile link" do
        page.must_have_link "Profile", href: user_path(@user)
      end

      it "displays a settings link" do
        page.must_have_link "Settings", href: edit_user_path(@user)
      end

      it "displays a sign out link" do
        page.must_have_link "Sign out", href: signout_path
      end

      it "hides the sign in link" do
        page.wont_have_link "Sign in", href: signin_path
      end

      describe "followed by sign out" do
        it "displays the sign in link" do
          click_link "Sign out"
          page.must_have_link "Sign in"
        end
      end
    end

    describe "with invalid information" do
      before do
        click_button "Sign in"
      end

      it "renders the form with errors" do
        page.must_have_selector "h1", text: "Sign In"
        page.must_have_selector 'div.alert.alert-error'
      end

      it "does not persist error messages to the next request" do
        click_link "Home"
        page.wont_have_selector 'div.alert.alert-error'
      end
    end
  end
end
