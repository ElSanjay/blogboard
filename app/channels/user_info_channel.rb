class UserInfoChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    reject and return if !current_user

    stream_from "user_info_channel_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
