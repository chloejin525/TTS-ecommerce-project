class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def update
  	user = User.find(params[:user_id])
  	user.update(role: params[:role])
  	redirect_back fallback_location: users_path
  end

end
