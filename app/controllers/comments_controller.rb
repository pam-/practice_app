class CommentsController < ApplicationController
	before_action :signed_in_user

	def create
		@post = Post.find(params[:comment][:post_id])
		@comment = @post.comments.build(comments_params)
		@comment.user = current_user


		if @comment.save
			flash[:success] = "Successfully posted!"
			redirect_to @post
		else 
			flash[:error] = " Whoops, something went wrong!"
			redirect_to @post
		end 
	end

	def destroy
		@comment.destroy
		redirect_to @post
	end

	private 

	def comments_params
		params.require(:comment).permit(:content, :post_id, :user_id)
	end
end 