class PostRelationshipsController < ApplicationController
	before_action :signed_in_user

	def create
		@post = Experience.find(params[:post_relationship][:followed_id])
		current_user.follow_post!(@post)
		respond_to do |format|
			format.html { redirect_to @post}
			format.js
		end 
	end

	def destroy
		@post = Experience.find(params[:id])
		current_user.unfollow_post!(@post) if current_user.following_post?(@post)
		respond_to do |format|
			format.html { redirect_to @post }
			format.js
		end 
	end
end 