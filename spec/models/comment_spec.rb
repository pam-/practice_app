require 'rails_helper'

RSpec.describe Comment, :type => :model do
  let(:comment) { Comment.new(content: "Hey") }

  subject { comment }

  it { should respond_to(:post) }
  it { should respond_to(:content) }

  describe "nil comment" do
  	before { comment.content = nil }
  	it { should_not be_valid }
  end

  
end
