class UserApiCallJob < ApplicationJob
  queue_as :default

  def perform(user)
    api = user.api_call
    user.update_db_and_leaderboard(api, user)
  end
end
