class CustomApiCallJob < ApplicationJob
  queue_as :default

  def perform(*args)
    api = args[0].custom_api_call(args[1], args[2])

    args[0].update_custom_leaderboard(api, args[3])
    # Do something later
  end

  after_perform do |job|

    stream_notification = "custom_filter_channel"

    boardtype = job.arguments[3]
    ActionCable.server.broadcast stream_notification, {message: boardtype}

  end
end
