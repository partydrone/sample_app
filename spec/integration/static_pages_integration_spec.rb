require 'minitest_helper'

describe "Static pages integration" do
  describe "Home page" do
    before do
      visit root_path
    end

    it "displays 'Sample App' in the heading" do
      page.must_have_selector 'h1', text: 'Sample App'
    end

    it "displays 'Sample App' in the title" do
      page.must_have_selector 'title', text: 'Sample App'
    end

    describe "when signed in" do
      it "renders the user's feed" do
        user = Factory(:user)
        Factory(:micropost, user: user, content: "Lorem ipsum")
        Factory(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
        user.feed.each do |item|
          page.must_have_selector "li##{item.id}", text: item.content
        end
      end
    end
  end

  describe "Help page" do
    before do
      visit help_path
    end

    it "displays 'Help' in the heading" do
      page.must_have_selector 'h1', text: 'Help'
    end

    it "displays 'Help' in the title" do
      page.must_have_selector 'title', text: 'Help'
    end
  end

  describe "About page" do
    before do
      visit about_path
    end

    it "displays 'About Us' in the heading" do
      page.must_have_selector 'h1', text: 'About Us'
    end

    it "displays 'About Us' in the title" do
      page.must_have_selector 'title', text: 'About Us'
    end
  end

  describe "Contact page" do
    before do
      visit contact_path
    end

    it "displays 'Contact Us' in the heading" do
      page.must_have_selector 'h1', text: 'Contact Us'
    end

    it "displays 'Contact Us' in the title" do
      page.must_have_selector 'title', text: 'Contact Us'
    end
  end
end