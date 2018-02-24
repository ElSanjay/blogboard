# Preview all emails at http://localhost:3000/rails/mailers/user_connected_mailer
class UserConnectedMailerPreview < ActionMailer::Preview
  def connected_mailer_preview
    UserConnectedMailer.with(user: User.first).connected_email
  end
end
