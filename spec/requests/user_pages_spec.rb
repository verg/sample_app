require 'spec_helper'

describe "UserPages" do

	subject { page }

  describe "signup page" do
  	before { visit signup_path }
  	
  	it { should have_h1('Sign up') }
  	it { should have_title(full_title('Sign up'))}
  end

  describe "Profile page" do
  	let(:user) { FactoryGirl.create(:user) }

  	before { visit user_path(user) }

   	it { should have_h1(user.name) }
  	it { should have_title(user.name) }
  end

  
  describe "signup_pathup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }
    let(:valid_name) {"Example User"}
    let(:valid_email) {"user@example.com"}
    let(:valid_password) {"foobar"}
    let(:valid_confirmation) {"foobar"}
    

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error')}
      end

    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: valid_name
        fill_in "Email",        with: valid_email
        fill_in "Password",     with: valid_password
        fill_in "Confirmation", with: valid_confirmation
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_title(user.name) }
        it { should have_success_message('Welcome') }
        it { should have_link('Sign out') }
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end