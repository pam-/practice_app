class ExperiencesController < ApplicationController

	before_action :signed_in_user, only: [:index, :create, :destroy]

	def index
		@experiences = Experience.paginate(page: params[:page], per_page: 10)
	end

  def show
    @experience = Experience.find(params[:id])
  end

	private

	def experience_params
		params.require(:experience).permit(:content, :title)
	end 

	def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."  #flash[:notice]
    end
  end

end 