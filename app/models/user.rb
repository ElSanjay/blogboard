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


  def update_database(api)
    self.update(data: api)

  end

  def update_leaderboard(board_type)
    
  self.data.each do |key, value|

    data = {}

    self.data[key]["reports"].first["data"]["rows"].each { |item|
      data[item["dimensions"].first]=item["metrics"].first["values"].first
    }

    case board_type

    when "mainboard"
      params = {
        board_name: board_type+"_"+key,
        name: self.name,
        avatar: self.image,
        score: self.data[key]["reports"].first["data"]["totals"].first["values"].first,
        id: self.id,
        organic: data["Organic Search"],
        social: data["Social"],
        email: data["Email"],
        direct: data["Direct"],
        paid: data["Paid"]
      }
    when "organic_search"
      params = {
        board_name: board_type+"_"+key,
        name: self.name,
        avatar: self.image,
        score: data["Organic Search"],
        id: self.id
      }
    when "social"
      params = {
        board_name: board_type+"_"+key,
        name: self.name,
        avatar: self.image,
        score: data["Social"],
        id: self.id
      }
    when "email"
      params = {
        board_name: board_type+"_"+key,
        name: self.name,
        avatar: self.image,
        score: data["Email"],
        id: self.id
      }
    when "direct"
      params = {
        board_name: board_type+"_"+key,
        name: self.name,
        avatar: self.image,
        score: data["Direct"],
        id: self.id
      }
    when "paid"
      params = {
        board_name: board_type+"_"+key,
        name: self.name,
        avatar: self.image,
        score: data["Paid"],
        id: self.id
      }
    end

    Boards::UpdateService.new.execute(params)

  end
  end

  def api_call
    datas = {}

    analytics = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new

    refresh(self)

    auth_client = Signet::OAuth2::Client.new(
      access_token: self.access_token
    )
    auth_client.expires_in = Time.now + 1_000_000
    analytics.authorization = auth_client

    dates = {
      last_month: Google::Apis::AnalyticsreportingV4::DateRange.new(start_date: Date.today.prev_month.beginning_of_month, end_date: Date.today.prev_month.end_of_month),
      this_month: Google::Apis::AnalyticsreportingV4::DateRange.new(start_date: Date.today.beginning_of_month, end_date: 'today'),
      last_week: Google::Apis::AnalyticsreportingV4::DateRange.new(start_date: Date.today.prev_week, end_date: Date.today.prev_week.end_of_week),
      this_week: Google::Apis::AnalyticsreportingV4::DateRange.new(start_date: Date.today.beginning_of_week, end_date: 'today')
    }
    # custom = Google::Apis::AnalyticsreportingV4::DateRange.new(start_date: '30DaysAgo', end_date: 'today')

    # date_range = Google::Apis::AnalyticsreportingV4::DateRange.new(start_date: '30DaysAgo', end_date: 'today')
    dimension = Google::Apis::AnalyticsreportingV4::Dimension.new(name: 'ga:channelGrouping')

    dates.each do |key, date|
      request = Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
        report_requests: [Google::Apis::AnalyticsreportingV4::ReportRequest.new(
          view_id: self.view_id,
          dimensions: [dimension],
          date_ranges: [date]
        )]
      )


      response = analytics.batch_get_reports(request)

      datas[key] = response


    end
    datas
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

  def update_db_and_leaderboard(data)

    self.update_database(data)

    self.update_leaderboard("mainboard")
    self.update_leaderboard("organic_search")
    self.update_leaderboard("social")
    self.update_leaderboard("email")
    self.update_leaderboard("direct")
    self.update_leaderboard("paid")
  end
end
