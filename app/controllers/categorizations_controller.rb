class CategorizationsController < ApplicationController

	before_action :signed_in_user

	def create
		@post = Post.find(params[:categorization][:post_id])
		logger.debug " Post attributes: #{@post.attributes.inspect}"
		@category = Category.find(params[:categorization][:category_id])
		logger.debug " Category: #{@category.attributes.inspect}"
		@post.categorize_into!(@category)

		respond_to do |format|
			format.html { redirect_to @post }
			format.json { render json: @post, status: :created, location: @post }
			format.js
		end 
	end

end 