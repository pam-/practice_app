class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following_posts]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def index
    @users = User.paginate(page: params[:page], per_page: 10)
  end 

  def show
  	@user = User.find(params[:id])
    @experience = current_user.experiences.build if signed_in?
    @experiences = @user.experiences.paginate(page: params[:page], per_page: 5)
    @feed_items = @user.followed_posts.paginate(page: params[:page])
  end 

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      sign_in(@user)
  		redirect_to @user
  		flash[:success] = "Welcome! Happy venting!"
  	else 
  		render 'new'
  	end 
  end 

  def edit
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Successfully updated"
      redirect_to @user
    else 
      render 'edit'
    end 
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  private 

  def user_params
  	params.require(:user).permit(:name, :email, :password, :password_confirmation) #admin is not an option for security reasons
  end 

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

   def admin_user
    redirect_to(root_url) if !current_user.admin?
  end

end