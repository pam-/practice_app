namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do 
		make_users
		make_posts
		#make_relationships
		make_posts_relationships
	end 
end 
		
	def make_users		
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
	end 

	def make_posts
		users = User.all.limit(4)
		20.times do
			title = "Title"
			content = Faker::Lorem.sentence(5)
			users.each { |user| user.posts.create!(content: content, title: title) }
		end
	end 

	# def make_relationships
	# 	users = User.all 
	# 	user = users.first
	# 	followed_users = users[2..15]
	# 	followers = users[3..8]
	# 	followed_users.each { |followed| user.follow!(followed) }
	# 	followers.each { |follower| follower.follow!(user) }
	# end

	def make_posts_relationships
		users = User.all
		posts = Post.all
		followers = users[1..10]
		followed_posts = posts[1..5]
		followers.each do |user| 
			followed_posts.each { |post| user.follow_post!(post) }
		end
	end