require 'rails_helper'

describe ApplicationHelper do
	
	describe "full_title" do

		it "should include the page title" do
			expect(full_title("foo")).to match(/foo/)
		end
	end
end