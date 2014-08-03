require 'rails_helper'

RSpec.describe Category, :type => :model do
  let!(:post) { FactoryGirl.create(:post) }
  let(:category) { FactoryGirl.create(:category) }
  let(:categorization) { post.categorizations.build(post_id: post.id, category_id: category.id) }

  subject { category }

  it { should respond_to(:posts) }
  it { should respond_to(:categorizations) }

  describe "when the category is a question" do
  	let(:question) { FactoryGirl.create(:category) }
  	before { post.categorize_into!(category) }

  	its(:posts) { should include(post) }
  end
end
