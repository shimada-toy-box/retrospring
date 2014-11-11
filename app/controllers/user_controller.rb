class UserController < ApplicationController
  def show
    @user = User.find_by_screen_name!(params[:username])
  end

  def edit
    authenticate_user!
  end

  def update
    authenticate_user!
    params.require(:display_name)
    current_user.display_name = params[:display_name]
    current_user.save!
    redirect_to edit_user_profile_path
  end
end
