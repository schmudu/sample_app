require 'spec_helper'

describe "StaticPages" do

  let(:web_site_title){"Ruby on Rails Tutorial Sample App"}
  subject { page }

  shared_examples_for "all static pages" do
    it {should have_selector('h1', text: heading) }
    it {should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path}
    let(:heading)         { 'Sample App' }
    let(:page_title)      { '' }

    it_should_behave_like "all static pages"
    it {should_not have_title('| Home)') }

    describe "for signed-in users" do
      let (:user) { FactoryGirl.create(:user) }
      before do
        30.times { FactoryGirl.create(:micropost, user: user, content: "Something") }
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "should list the number of posts by the user" do
        it { should have_content('30 microposts')}
      end

      describe "should have a pagination link if we add more links" do
        # add 20 more posts
        before do
          20.times { FactoryGirl.create(:micropost, user: user, content: "Something") }
          visit root_path
        end
        it { should have_selector('div.pagination')}
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end
  end

  describe "Help page" do
    before { visit help_path}
    let(:heading)         { 'Help' }
    let(:page_title)      { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before{visit about_path}
    it {should have_content('About')}
    it {should have_selector('h1', text:'About')}
    it {should have_title(full_title('About')) }
  end

  describe "Contact page" do
    before{visit contact_path}
    it {should have_selector('h1', text:'Contact')}
    it {should have_title(full_title('Contact')) }
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    expect(page).to have_title('Sample App')
  end
end
