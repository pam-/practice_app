require 'rails_helper'

RSpec.describe "Post Pages", :type => :request do
  
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
  				fill_in 'post_title', with: "Hello"
  				fill_in 'post_content', with: "Lorem ipsum" 
          #CODE TO CHOOSE CATEGORY
  			end 

  			it "should create a post" do
  				expect { click_button "Post" }.to change(Post, :count).by(1)
  			end
  		end

  		describe "with invalid information" do
  			before { fill_in 'post_content', with: " " }

  			it "should not create a post" do
  				expect { click_button('Post').to_not change(Post, :count) }
  			end
  		end

      describe "categorizing the post" do
        let(:user) { FactoryGirl.create(:user) }
        let(:post) { FactoryGirl.create(:post, user: user) }

        before do
          sign_in user
          visit post_path(post)
          #save_and_open_page 
       end 

        describe "creating a story" do
          before { click_button("Story") }

          its(:categories) { should include("Story") }
        end
      end
  	end
  end

  describe "visiting single post page" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:other_user) { FactoryGirl.create(:user) }
    let!(:post) { FactoryGirl.create(:post, user: other_user) }

    before do
      sign_in user
      visit post_path(post)
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
      it { should have_xpath("//input[@value='Unfollow Post']") }
    end

    describe "unfollowing a post" do
      before do 
        user.save
        user.follow_post!(post)
        visit post_path(post)
        #save_and_open_page 
      end 
      it " should decrease user's followed posts" do
        expect do
          click_button 'Unfollow'
        end.to change(user.followed_posts, :count).by(-1)
      end
    end

    describe "posting a reply" do
      before do
        sign_in user
        visit post_path(post)
      end

      it { should have_content('ANY THOUGHTS?') }
      it { should have_button('Submit') }

      describe "when hitting submit button" do
        before do
          fill_in 'comment_content', with: "Oy"
          #save_and_open_page
        end 

        it "should create a comment" do
          expect { click_button 'Submit' }.to change(Comment, :count).by(1)
        end

        it { should have_content("Oy") }

        describe " seeing the comment's author" do
          before { sign_in other_user; visit post_path(post) }
          let(:comment) { FactoryGirl.create(:comment, user: other_user) }

          it { should have_content(comment.name) }
        end
      end
    end
  end
end
