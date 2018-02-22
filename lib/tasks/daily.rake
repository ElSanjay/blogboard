namespace :daily do
  desc "TODO"
  task update: :environment do
    users = User.all
    users.each do |user|
      UserApiCallJob.perform_later user
    end
    Rails.logger.info("Leaderboard updated at #{Time.now}")
  end

end
