require 'rails_helper'

RSpec.describe Experience, :type => :model do
  let(:user) { FactoryGirl.create(:user) }
  before { @experience = user.experiences.build(content: "Lorem ipsum") }

  subject { @experience }

  it { should respond_to(:content) }
  it { should respond_to(:user_id ) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
  	before { @experience.user_id = nil }
  	it { should_not be_valid }
  end
end
