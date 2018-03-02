class UserApiCallJob < ApplicationJob
  queue_as :default

  before_perform do |job|

    # byebug

  end

  def perform(user)

    api = user.api_call

    user.update_db_and_leaderboard(api)

    stream_id = "user_info_channel_#{user.id}"


    ActionCable.server.broadcast stream_id, {message: "You have successfully connected and your data will be populated"}

  end

  rescue_from(StandardError) do |exception|

    stream_id = "user_info_channel_#{arguments[0].id}"


    ActionCable.server.broadcast stream_id, {message: exception}
  end

  after_perform do |job|

    record = job.arguments.first
    if record.first_time
      UserConnectedMailer.with(user: record).connected_email.deliver_later
    end

  end
end
