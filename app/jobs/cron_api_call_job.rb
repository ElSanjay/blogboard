class CronApiCallJob < ApplicationJob
  queue_as :default

  def perform(user)
    api = user.api_call
    user.update_db_and_leaderboard(api)
  end
end
