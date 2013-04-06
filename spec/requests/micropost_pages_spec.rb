require 'spec_helper'

describe "Micropost pages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }      
      end
    end

    describe "with valid information" do
      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end

  describe "Sidebar micropost count" do
    before { visit root_path }

    describe "with no microposts" do
      it { should have_selector("span", content: "0 micropost") }
    end

    describe "with 1 micropost" do
      before { FactoryGirl.create(:micropost, user: user) }

      it { should have_selector("span", content: "1 micropost") }
    end

    describe "with 2 microposts" do
      
      before { FactoryGirl.create(:micropost, user: user) }
      before { FactoryGirl.create(:micropost, user: user) }

      it { should have_selector("span", content: "2 microposts") }
    end

    describe "pluralized count" do
      
      before { FactoryGirl.create(:micropost, user: user) }
      before { FactoryGirl.create(:micropost, user: user) }
    end
  end

  describe "pagination" do

    before(:each) { 31.times { FactoryGirl.create(:micropost, user: user) } }
    before { visit root_path }

    it { should have_selector('div.pagination') }
    it { should have_selector("li", :content => "Previous") }
    it { should have_selector("a", :href => "/users/1?page=2", :content => "2") }
    it { should have_selector("a", :href => "/users/1?page=2", :content => "Next") }
  end
end
