class PostsController < ApplicationController

	before_action :signed_in_user, only: [:index, :create, :destroy, :followers]

	def index
		@posts = Post.paginate(page: params[:page], per_page: 10)
	end

  def show
    @post = Post.find(params[:id])
    @comment = @post.comments if signed_in?
    @comments = @post.comments.paginate(page: params[:page])
  end

  def create 
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post created!"
      redirect_to @post
    else 
      flash.now[:error] = "Couldn't post!"
      redirect_to :back
    end
  end

  def categorize
    @category = Category.find_by(params[:name])

    if input[:name] == params[:name]
      @post.categorizations.build(category_id: @category.id)
    else
      flash[:error] = "Something went wrong"
    end 
  end

  def destroy
    Post.find(params[:id]).destroy
    flash[:success] = "Successfully deleted!"
    redirect_to current_user
  end

	private

	def post_params
		params.require(:post).permit(:content, :title)
	end 

	def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."  #flash[:notice]
    end
  end

end 