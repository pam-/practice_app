require 'rails_helper'

RSpec.describe Experience, :type => :model do
  let(:user) { FactoryGirl.create(:user) }
  before { @experience = user.experiences.build(content: "Lorem ipsum", title: "Wassap") }

  subject { @experience }

  it { should respond_to(:content) }
  it { should respond_to(:title)}
  it { should respond_to(:user_id ) }
  it { should respond_to(:user) }
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

  describe "too long" do
    before { @experience.content = "a" * 141 } #set the new value to the experience before anything is done 
    it { should_not be_valid }
  end

end
