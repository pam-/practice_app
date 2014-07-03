require 'rails_helper'

RSpec.describe PostRelationship, :type => :model do
  let(:follower) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  let(:followed_post) { FactoryGirl.create(:experience, user: other_user) }
  let(:post_relationship) { follower.post_relationships.build(followed_id: followed_post.id) }

  subject { post_relationship }

  it { should be_valid }

  describe "follower methods" do
  	it { should respond_to(:follower) }
  	it { should respond_to(:followed) }

  	its(:follower) { should eq follower }
  	its(:followed) { should eq followed_post }
  end

  describe "follower id is emply" do
  	before { post_relationship.follower_id = nil }
  	it { should_not be_valid }
  end

  describe "followed is is empty" do
  	before { post_relationship.followed_id = nil }
  	it { should_not be_valid }
  end
end
