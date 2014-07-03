require 'rails_helper'

RSpec.describe Experience, :type => :model do
  let(:user) { FactoryGirl.create(:user) }
  before { @experience = user.experiences.build(content: "Lorem ipsum", title: "Wassap") }

  subject { @experience }

  it { should respond_to(:content) }
  it { should respond_to(:title)}
  it { should respond_to(:user_id ) }
  it { should respond_to(:user) }
  it { should respond_to(:post_relationships) }
  it { should respond_to(:followers) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
  	before { @experience.user_id = nil }
  	it { should_not be_valid }
  end

  describe "with blank content" do
    before { @experience.content = " " }
    it { should_not be_valid }
  end

  describe "with blank title" do
    before { @experience.title = " " }
    it { should_not be_valid }
  end

  # describe "too long" do
  #   before { @experience.content = "a" * 141 } #set the new value to the experience before anything is done 
  #   it { should_not be_valid }
  # end

  describe "getting a follower" do
    let(:other_user) { FactoryGirl.create(:user) }
    before { @experience.save; other_user.follow_post!(@experience) }
    its(:followers) { should include(other_user) }
  end

end
