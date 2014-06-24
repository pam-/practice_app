namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do 
		admin = User.create!(name: "pam_yam",
								 email: "pam.assogba@gmail.com",
								 password: "lovely1992",
								 password_confirmation: "lovely1992",
								 admin: true)
		20.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@tailstutorial.org"
			password = "password"
			User.create!(name: name,
									 email: email,
									 password: password,
									 password_confirmation: password)
		end

		users = User.all.limit(4)
		20.times do
			title = "Title"
			content = Faker::Lorem.sentence(5)
			users.each { |user| user.experiences.create!(content: content, title: title) }
		end
	end 
end