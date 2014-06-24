require 'rails_helper'

RSpec.describe "Experience Pages", :type => :request do
  
  subject { page }

  let(:user) { FactoryGirl.create(:user, name: "Jojo", email: "jojo@example.com") }
  let(:user2) { FactoryGirl.create(:user, name: "Coco", email: "coco@example.com") }
  before { sign_in user }

  describe "post creation" do
  	before { visit user_path(user2) }

  	describe "visiting other user's page" do
  		
  		it { should_not have_button("Post") }
  	end

  	describe "visiting current user page" do
  		before { visit user_path(user) }

  		describe "with valid information" do

  			before do 
  				fill_in 'experience_title', with: "Hello"
  				fill_in 'experience_content', with: "Lorem ipsum" 
  			end 

  			it "should create a post" do
  				expect { click_button "Post" }.to change(Experience, :count).by(1)
  			end
  		end

  		describe "with invalid information" do
  			before { fill_in 'experience_content', with: " " }

  			it "should not create a post" do
  				expect { click_button('Post').to_not change(Experience, :count) }
  			end
  		end
  	end
  end
end
