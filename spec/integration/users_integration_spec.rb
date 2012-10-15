require 'minitest_helper'

describe "User pages integration" do
  describe "index" do
    before do
      @user = Factory(:user)
      sign_in @user
      30.times { Factory(:user) }
      visit users_path
    end

    it "displays a page heading" do
      page.must_have_selector 'h1', text: 'All Users'
    end

    it "displays a page title" do
      page.must_have_selector 'title', text: 'Users'
    end

    describe "pagination" do
      it "lists each user" do
        User.paginate(page: 1).each do |user|
          page.must_have_selector 'li > a', text: user.name
        end
      end

      it "displays pagination controls" do
        page.must_have_selector 'div.pagination'
      end
    end

    describe "delete links" do
      it "hides delete links by default" do
        page.wont_have_link 'delete'
      end

      describe "as an admin" do
        before do
          @user.toggle! :admin
          sign_in @user
          visit users_path
        end

        it "shows delete links" do
          page.must_have_link 'delete'
        end

        it "hides delete link for current user" do
          page.wont_have_link 'delete', href: user_path(@user)
        end

        it "removes user from the database when clicked" do
          count = User.count
          click_link 'delete'
          User.count.must_equal count - 1
        end
      end
    end
  end

  describe "Sign up" do
    before do
      visit signup_path
    end

    it "displays 'Sign Up' in the heading" do
      page.must_have_selector "h1", text: "Sign Up"
    end

    it "displays 'Sign Up' in the title" do
      page.must_have_selector "title", text: "Sign Up"
    end

    describe "with valid info" do
      before do
        @count = User.count
        fill_in "Name", with: "Barney Rubble"
        fill_in "Email", with: "brubble@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
        click_button "Create my account"
      end

      it "creates a new user" do
        User.count.must_equal @count + 1
      end

      it "displays the user's profile" do
        page.must_have_selector "h1", text: "Barney Rubble"
      end

      it "displays a success message" do
        page.must_have_selector 'div.alert.alert-success'
      end
    end

    describe "with invalid info" do
      before do
        @count = User.count
        click_button "Create my account"
      end

      it "doesn't create a new user" do
        User.count.must_equal @count
      end

      it "renders the form" do
        page.must_have_selector "h1", text: "Sign Up"
      end

      it "displays errors" do
        page.must_have_content "error"
      end

      it "hides password digest error" do
        page.wont_have_content "Password digest"
      end
    end
  end

  describe "Profile page" do
    before do
      @user = Factory(:user, name: "Barney Rubble")
      @post1 = Factory(:micropost, user: @user, content: 'Foo')
      @post2 = Factory(:micropost, user: @user, content: 'Bibble')
      visit user_path(@user)
    end

    it "displays the user name in the heading" do
      page.must_have_selector "h1", text: @user.name
    end

    it "displays the user name in the title" do
      page.must_have_selector "title", text: @user.name
    end

    it "shows the first micropost" do
      page.must_have_content @post1.content
    end

    it "shows a second micropost" do
      page.must_have_content @post2.content
    end

    it "shows the number of microposts" do
      page.must_have_content "#{@user.microposts.count}"
    end

    it "shows pagination controls for microposts" do
      skip "complete as exercise"
      50.times { Factory(:micropost, user: @user) }
      page.must_have_selector 'div.pagination'
    end

    describe "follow/unfollow buttons" do
      before do
        @other_user = Factory(:user)
        sign_in @user
      end

      describe "following a user" do
        before do
          visit user_path(@other_user)
        end

        it "increases the followed user count" do
          count = @user.followed_users.count
          click_button 'Follow'
          @user.followed_users.count.must_equal count + 1
        end

        it "increases the other user's followers count" do
          count = @other_user.followers.count
          click_button 'Follow'
          @other_user.followers.count.must_equal count + 1
        end

        it "toggles the follow button" do
          click_button 'Follow'
          page.must_have_selector 'input', value: 'Unfollow'
        end
      end

      describe "unfollowing a user" do
        before do
          @user.follow! @other_user
          visit user_path(@other_user)
        end

        it "decreases the followed user count" do
          count = @user.followed_users.count
          click_button 'Unfollow'
          @user.followed_users.count.must_equal count - 1
        end

        it "decreases the other user's followers count" do
          count = @other_user.followers.count
          click_button 'Unfollow'
          @other_user.followers.count.must_equal count - 1
        end

        it "toggles the follow button" do
          click_button 'Unfollow'
          page.must_have_selector 'input', value: 'Follow'
        end
      end
    end
  end

  describe "Edit user" do
    before do
      @user = Factory(:user)
      sign_in @user
      visit edit_user_path(@user)
    end

    it "displays 'Update your profile' in the heading" do
      page.must_have_selector "h1", text: "Update your profile"
    end

    it "displays 'Edit Profile' in the title" do
      page.must_have_selector "title", text: "Edit Profile"
    end

    it "displays a link to change the user's gravatar image" do
      page.must_have_link "change", href: "http://gravatar.com/emails"
    end

    describe "with valid info" do
      before do
        @name = "New Name"
        @email = "new@example.com"
        fill_in "Name", with: @name
        fill_in "Email", with: @email
        fill_in "Password", with: @user.password
        fill_in "Confirm Password", with: @user.password
        click_button "Save changes"
      end

      it "redirects to the user's profile" do
        page.must_have_selector 'h1', text: @name
      end

      it "displays the sign out link" do
        page.must_have_link 'Sign out', href: signout_path
      end

      it "displays a success message" do
        page.must_have_selector 'div.alert.alert-success'
      end

      it "updates the user's name in the database" do
        @user.reload.name.must_equal @name
      end

      it "updates the user's email in the database" do
        @user.reload.email.must_equal @email
      end
    end

    describe "with invalid info" do
      before do
        click_button "Save changes"
      end

      it "renders the form" do
        page.must_have_selector "h1", text: "Update your profile"
      end

      it "displays errors" do
        page.must_have_content "error"
      end
    end
  end

  describe "following/followers" do
    before do
      @user       = Factory(:user)
      @other_user = Factory(:user)
      @user.follow! @other_user
    end

    describe "followed users (following)" do
      before do
        sign_in @user
        visit following_user_path(@user)
      end

      it "displays a custom title" do
        page.must_have_selector 'title', text: 'Following'
      end

      it "displays a custom heading" do
        page.must_have_selector 'h3', text: 'Following'
      end

      it "links to other user's profile" do
        page.must_have_link @other_user.name, href: user_path(@other_user)
      end
    end

    describe "followers" do
      before do
        sign_in @other_user
        visit followers_user_path(@other_user)
      end

      it "displays a custom title" do
        page.must_have_selector 'title', text: 'Followers'
      end

      it "displays a custom heading" do
        page.must_have_selector 'h3', text: 'Followers'
      end

      it "links to other user's profile" do
        page.must_have_link @user.name, href: user_path(@user)
      end
    end
  end
end
