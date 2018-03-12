class UsersController < ApplicationController

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to authentications_path, notice: "You have successfully update your view id"
      

    else

    end
  end

  private

  def user_params
    params.require(:user).permit(:view_id)
  end

end
