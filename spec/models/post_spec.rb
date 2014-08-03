require 'rails_helper'

RSpec.describe Post, :type => :model do
  let(:user) { FactoryGirl.create(:user) }
  let!(:post) { FactoryGirl.create(:post, user: user, content: "Lorem ipsum", title: "Wassap" ) }

  subject { post }

  it { should respond_to(:content) }
  it { should respond_to(:title)}
  it { should respond_to(:user_id ) }
  it { should respond_to(:user) }
  it { should respond_to(:post_relationships) }
  it { should respond_to(:followers) }
  it { should respond_to(:categories) }
  it { should respond_to(:categorizations) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
  	before { post.user_id = nil }
  	it { should_not be_valid }
  end

  describe "with blank content" do
    before { post.content = " " }
    it { should_not be_valid }
  end

  describe "with blank title" do
    before { post.title = " " }
    it { should_not be_valid }
  end

  describe "getting a follower" do
    let(:other_user) { FactoryGirl.create(:user) }
    before { post.save; other_user.follow_post!(post) }
    its(:followers) { should include(other_user) }
  end

  describe "being categorized" do
    let(:category) { FactoryGirl.create(:category) }
    before { post.save; post.categorize_into!(category) }
    its(:categories) { should include(category) }
  end
end
