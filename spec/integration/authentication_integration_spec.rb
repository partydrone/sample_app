require 'minitest_helper'

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
        sign_in @user
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

      it "displays a users link" do
        page.must_have_link 'Users', href: users_path
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

  describe "authorization" do
    describe "for signed-out users" do
      before do
        @user = Factory(:user)
      end

      describe "when attempting to visit a protected page" do
        it "redirects to desired page after sign in" do
          visit edit_user_path(@user)
          fill_in 'Email', with: @user.email
          fill_in 'Password', with: @user.password
          click_button 'Sign in'
          page.must_have_selector 'title', text: 'Edit Profile'
        end
      end

      describe "in the users controller" do
        describe "visiting the edit page" do
          before do
            visit edit_user_path(@user)
          end

          it "redirects to the sign in page" do
            page.must_have_selector 'title', text: 'Sign In'
          end

          it "alerts the user to sign in" do
            page.must_have_selector 'div.alert.alert-notice'
          end
        end

        describe "visiting the index page" do
          before do
            visit users_path
          end

          it "requires sign in" do
            page.must_have_selector 'title', text: 'Sign In'
          end
        end

        describe "visiting the following page" do
          before do
            visit following_user_path(@user)
          end

          it "requires sign in" do
            page.must_have_selector 'title', text: 'Sign In'
          end
        end

        describe "visiting the followers page" do
          before do
            visit followers_user_path(@user)
          end

          it "requires sign in" do
            page.must_have_selector 'title', text: 'Sign In'
          end
        end
      end
    end

    describe "for wrong user" do
      before do
        @user = Factory(:user)
        @wrong_user = Factory(:user, email: 'wrong@example.com')
        sign_in @user
      end

      describe 'visiting Users#edit page' do
        before do
          visit edit_user_path(@wrong_user)
        end

        it "doesn't show the edit page" do
          page.wont_have_selector 'title', text: 'Edit Profile'
        end
      end
    end
  end
end
