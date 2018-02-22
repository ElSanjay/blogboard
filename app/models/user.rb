class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]



  def self.from_omniauth(auth)
   where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
     user.provider = auth.provider
     user.uid = auth.uid
     user.email = auth.info.email
     user.name = auth.info.name
     user.image = auth.info.image
     user.password = Devise.friendly_token[0,20]
     user.access_token = auth.credentials.token
     user.refresh_token = auth.credentials.refresh_token
     user.oauth_expires_at = Time.at(auth.credentials.expires_at)
     user.save!
   end
 end

 def refresh_token_if_expired
    if token_expired?
      response = RestClient.post "https://accounts.google.com/o/oauth2/token", :grant_type => 'refresh_token', :refresh_token => self.refresh_token, :client_id => ENV['GOOGLE_CLIENT_ID'], :client_secret => ENV['GOOGLE_CLIENT_SECRET']
      refreshhash = JSON.parse(response.body)

      access_token_will_change!
      oauth_expires_at_will_change!

      self.access_token = refreshhash['access_token']
      self.oauth_expires_at = DateTime.now + refreshhash["expires_in"].to_i.seconds

      self.save
      puts 'Saved'
    end
  end

  def token_expired?
    expiry = Time.at(self.oauth_expires_at)
    return true if expiry < Time.now
    token_expires_at = expiry
    save if changed?
    false
  end


  def update_database(api)
    self.update(data: api)

  end

  def update_leaderboard(board_type)

    data = {}
    self.data["reports"].first["data"]["rows"].each { |item|
      data[item["dimensions"].first]=item["metrics"].first["values"].first
    }
    case board_type

    when "mainboard"
      params = {
        board_name: board_type,
        name: self.name,
        score: self.data["reports"].first["data"]["totals"].first["values"].first,
        id: self.id,
        organic: data["Organic Search"],
        social: data["Social"],
        email: data["Email"],
        direct: data["Direct"],
        paid: data["Paid"]
      }
    when "organic_search"
      params = {
        board_name: board_type,
        name: self.name,
        score: data["Organic Search"],
        id: self.id
      }
    when "social"
      params = {
        board_name: board_type,
        name: self.name,
        score: data["Social"],
        id: self.id
      }
    when "email"
      params = {
        board_name: board_type,
        name: self.name,
        score: data["Email"],
        id: self.id
      }
    when "direct"
      params = {
        board_name: board_type,
        name: self.name,
        score: data["Direct"],
        id: self.id
      }
    when "paid"
      params = {
        board_name: board_type,
        name: self.name,
        score: data["Paid"],
        id: self.id
      }
    end

    Boards::UpdateService.new.execute(params)
  end

  def api_call

    analytics = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new

    refresh(self)

    auth_client = Signet::OAuth2::Client.new(
      access_token: self.access_token
    )
    auth_client.expires_in = Time.now + 1_000_000
    analytics.authorization = auth_client

    date_range = Google::Apis::AnalyticsreportingV4::DateRange.new(start_date: '30DaysAgo', end_date: 'today')
    dimension = Google::Apis::AnalyticsreportingV4::Dimension.new(name: 'ga:channelGrouping')

    request = Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
      report_requests: [Google::Apis::AnalyticsreportingV4::ReportRequest.new(
        view_id: self.view_id,
         dimensions: [dimension],
         date_ranges: [date_range]
      )]
    )

    response = analytics.batch_get_reports(request)

  end

  def refresh(user)
    # Refresh auth token from google_oauth2.
     options = {
      body: {
        client_id: ENV['GOOGLE_CLIENT_ID'],
        client_secret: ENV['GOOGLE_CLIENT_SECRET'],
        refresh_token: "#{user.refresh_token}",
        grant_type: "refresh_token"
      },
      headers: {
        'Content-Type' => 'application/x-www-form-urlencoded'

      }
    }

    refresh = HTTParty.post("https://accounts.google.com/o/oauth2/token", options)

      if refresh.code == 200

        user.access_token = refresh.parsed_response['access_token']
        user.save
      end
  end
  
  def update_db_and_leaderboard(data, user)
    user.update_database(data)
    user.update_leaderboard("mainboard")
    user.update_leaderboard("organic_search")
    user.update_leaderboard("social")
    user.update_leaderboard("email")
    user.update_leaderboard("direct")
    user.update_leaderboard("paid")
  end
end
