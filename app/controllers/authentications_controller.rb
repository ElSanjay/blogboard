class AuthenticationsController < ApplicationController
  include HTTParty

  before_action :authenticate_user!, :only => [:auth, :api_update]


  def show
  end

  def auth

    check_data
    UserApiCallJob.perform_later(current_user)
    redirect_to authentications_path

  end


  private

  def check_data
    if !current_user.data
      current_user.update(view_id: params[:view_id], first_time: true)
    else
      current_user.update(view_id: params[:view_id], first_time: false)
    end
  end

end
