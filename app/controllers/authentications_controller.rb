class AuthenticationsController < ApplicationController
  include HTTParty

  before_action :authenticate_user!, :only => [:auth, :api_update]


  def show
  end

  def auth

    if !current_user.view_id
      current_user.update(view_id: params[:view_id], first_time: true)

    else
      current_user.update(view_id: params[:view_id], first_time: false)
    end



    UserApiCallJob.perform_later(current_user)

    # flash[:notice] = "Your data is updated. It may take a while to populate. Keep updated."

    redirect_to authentications_path

  end

  # def api_update
  #
  #
  #   UserApiCallJob.perform_later current_user
  #   redirect_to authentications_path
  #
  # end

  def auto_update
    @users = User.all
    @users.each do |user|
      view_id = user.uid
      token = user.access_token
      UserApiCallJob.perform_later user
    end
    redirect_to test_index_path
  end










end
