require 'rails_helper'

RSpec.describe User, :type => :model do
  
  before do
    @user = User.new(name: "User", email: "user@example.com", password: "foobar", 
                     password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:posts) }
  it { should respond_to(:admin) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }
  it { should respond_to(:post_relationships) }
  it { should respond_to(:followed_posts) }
  it { should respond_to(:following_post?) }
  it { should respond_to(:follow_post!) }
  it { should respond_to(:unfollow_post!) }


  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end
    it { should be_admin }
  end

  describe "when name is not present" do
  	before { @user.name = '' }
  	it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = 'a' * 51 }
    it { should_not be_valid }
  end

  describe "when email is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end 

    it { should_not be_valid }
  end

  describe "when password is not present" do
    before do
      @user = User.new(name: "User", email: "user@example.com", password: " ", 
                     password_confirmation: " ")
    end 
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch"}
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe " with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_falsey }
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "post associations" do
    
    before { @user.save }
    let!(:older_post) do
      FactoryGirl.create(:post, user: @user, created_at: 1.day.ago)
    end 
    let!(:newer_post) { FactoryGirl.create(:post, user: @user, created_at: 1.hour.ago)  }

    it "should have the right posts in the right order" do
      expect(@user.posts.to_a).to eq [newer_post, older_post]
    end

    it "should destroy associated posts" do
      posts = @user.posts.to_a
      @user.destroy
      expect(posts).not_to be_empty
      posts.each do |post|
        expect(Post.where(id: post.id)).to be_empty
      end 
    end
  end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end

    describe "unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end

  describe "following a post" do
    let(:other_user) { FactoryGirl.create(:user) }
    let(:post) { FactoryGirl.create(:post, user: other_user, created_at: 1.day.ago) }

    before do
      @user.save
      @user.follow_post!(post)
    end

    it { should be_following_post(post) }
    its(:followed_posts) { should include(post) }

    describe "unfollowing a post" do
      before { @user.unfollow_post!(post) }

      it { should_not be_following_post(post) }
      its(:followed_posts) { should_not include(post) }
    end
  end
end
