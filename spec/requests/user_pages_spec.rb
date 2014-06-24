require 'rails_helper'

RSpec.describe "UserPages", :type => :request do

	subject { page }

  describe "index" do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Pam", email: "pam@example.com")
      FactoryGirl.create(:user, name: "Lala", email: "lala@example.com")
      visit users_path #index
    end

    it { should have_title('All users') }

    it "should list all users" do
      User.all.each do |user|
        expect(page).to have_selector('li', text: user.name)
      end 
    end

    describe "admin" do
      let(:admin) { FactoryGirl.create(:admin) }
      before do
        sign_in admin
        visit users_path
      end

      it { should have_link('delete') }
      it "should be able to delete another user" do
        expect do
          click_link('delete', match: :first)
        end.to change(User, :count).by(-1)
      end
      it { should_not have_link('delete', href: user_path(admin)) }
    end
  end

	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:experience, user: user, title: "Oula", content: "Lolli") }

		before do
      sign_in user
      visit user_path(user)
    end  

		it { should have_content(user.name.upcase) }
		it { should have_title(user.name) }

    describe "experience on page" do
      it { should have_content(m1.content) }
      #it { should have_content(m1.title) }
    end
	end

  describe "signup page" do
  	before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "signup" do
  	before { visit signup_path }

  	let(:submit) { "Create Account" }

  	describe "with invalid information" do
  		it "should not create a user" do
  			expect { click_button submit }.not_to change(User, :count)
  		end
  	end

  	describe "with valid information" do
  		before do
  			fill_in "Username", 		with: "User"
  			fill_in "Email", 				with: "user@example.com"
  			fill_in "Password", 		with: "foobar"
  			fill_in "Confirmation", with: "foobar"
  		end 

  		it "should create a user" do
  			expect { click_button submit }.to change(User, :count).by(1)
  		end

  		describe "after saving the user" do

        before do
          click_button submit
        end 

        let(:user) { User.find_by(email: "user@example.com") }

  			#it { should have_link('Sign out') }
  			it { should have_title(user.name) }
  			it { should have_selector('div.alert-success', text: 'Welcome! Happy venting!') }
  		end
  	end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end 

    describe "page" do
      it { should have_content('UPDATE YOUR PROFILE') }
      it { should have_title('Edit user') }
    end

    describe "with invalid information" do
      before { click_button 'Save Changes' }

      it { should have_selector('div.alert-error') }
    end

    describe "with valid information" do
      let(:new_name) { "NewName" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Username", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirmation", with: user.password
        click_button "Save Changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end

  describe "experiences index do" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in user
      visit experiences_path
    end

    it { should have_title('Stories') }
    it { should have_selector('li') }
    it { should have_content(user.name) }
    #it { should have_link("Reply", href: reply_path)}
  end
end
