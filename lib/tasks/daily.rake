namespace :daily do
  desc "TODO"
  task update: :environment do
    users = User.all
    users.each do |user|
      CronApiCallJob.perform_later user
    end

  end

end
