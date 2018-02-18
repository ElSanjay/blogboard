class TestController < ApplicationController
  require 'google/api_client/client_secrets'

  def index
    



  end

  def callback
    if params[:error]
      flash[:alert] = params[:error]
      redirect_to root_path
    else
      client_secrets = Google::APIClient::ClientSecrets.load

      auth_client = client_secrets.to_authorization
      auth_client.update!(
        :scope => 'https://www.googleapis.com/auth/analytics.readonly',
        :redirect_uri => 'http://localhost:3000/test/callback'
      )

      if request['code'] == nil

        auth_uri = auth_client.authorization_uri({
          "include_granted_scopes" => "true",
          "access_type" => "offline"
        }).to_s

        redirect_to auth_uri
      else
        auth_client.code = request['code']

        auth_client.fetch_access_token!
        auth_client.client_secret = nil

        session[:credentials] = auth_client.to_json

        @api = api_call("169795793")
        byebug
        session.delete("credentials")
        byebug
        render "home/index"
      end
    end


  end

  def api_call(view_id)
    analytics = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
    credentials = JSON.parse(session[:credentials])
    auth_client = Signet::OAuth2::Client.new(credentials)

    analytics.authorization = auth_client

    date_range = Google::Apis::AnalyticsreportingV4::DateRange.new(start_date: '30DaysAgo', end_date: 'today')
    dimension = Google::Apis::AnalyticsreportingV4::Dimension.new(name: 'ga:channelGrouping')

    request = Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
      report_requests: [Google::Apis::AnalyticsreportingV4::ReportRequest.new(
        view_id: view_id,
         dimensions: [dimension],
         date_ranges: [date_range]
      )]
    )
    byebug

    response = analytics.batch_get_reports(request)
    byebug
    response.reports

  end

end
