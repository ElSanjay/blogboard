
set :output, {:error => 'log/error.log', :standard => 'log/standard.log'}
set :environment, "development"
# env :PATH, ENV['PATH']

every 1.day, at: '1:30 am' do # 1.minute 1.day 1.week 1.month 1.year is also supported
  rake "daily:update"

end
