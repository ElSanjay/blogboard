web: bundle exec puma -C config/puma.rb
bundle exec sidekiq -c 2 default -q mailers
