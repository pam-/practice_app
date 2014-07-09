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

  describe "visiting single post page" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:other_user) { FactoryGirl.create(:user) }
    let!(:post) { FactoryGirl.create(:experience, user: other_user) }

    before do
      sign_in user
      visit experience_path(post)
    end

    it { should have_button('Follow') }
    it { should have_content(post.content) }

    describe "following the post" do
      it " should increase user's followed posts" do
        expect do
          click_button 'Follow'
        end.to change(user.followed_posts, :count).by(1)
      end 
    end

    describe "toggling button to unfollow" do
      before { click_button 'Follow' }
      it { should have_xpath("//input[@value='Unfollow']") }
    end

    describe "unfollowing a post" do
      before do 
        user.save
        user.follow_post!(post)
        visit experience_path(post)
        #save_and_open_page 
      end 
      it " should decrease user's followed posts" do
        expect do
          click_button 'Unfollow'
        end.to change(user.followed_posts, :count).by(-1)
      end
    end
  end
end
