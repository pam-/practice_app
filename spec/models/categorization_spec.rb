require 'rails_helper'

RSpec.describe Categorization, :type => :model do
  let(:post) { FactoryGirl.create(:post) }
  let(:category) { FactoryGirl.create(:category) }
  let(:categorization) { FactoryGirl.create(:categorization, post_id: post.id, category_id: category.id) }

  subject { categorization }

  it { should respond_to(:post) }
  it { should respond_to(:category) }
end
