class UserConnectedMailer < ApplicationMailer
  default from: 'Blog Leaderboard'

  def connected_email
    @user = params[:user]
    @url  = root_url
    mail(to: @user.email, subject: "Hi, #{@user.name}")
  end
end
