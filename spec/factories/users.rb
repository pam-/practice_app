# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do 
		name "Pamela Assogba"
		email "pamela@example.com"
		password "poopoo"
		password_confirmation "poopoo"
	end 
end
