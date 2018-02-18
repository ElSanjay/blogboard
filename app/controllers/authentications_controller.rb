class AuthenticationsController < ApplicationController
  include AuthenticationsHelper
  before_action :authenticate_user!, :only => [:auth, :api_update]
  require 'google/api_client/client_secrets'

  def show
  end

  def auth

    if !current_user.uid
      current_user.update(uid: params[:view_id])
    end


      client_secrets = Google::APIClient::ClientSecrets.new(JSON.parse(ENV['GOOGLE_SECRET']))

      auth_client = client_secrets.to_authorization
      auth_client.update!(
        :scope => 'https://www.googleapis.com/auth/analytics.readonly',
        :redirect_uri => 'http://localhost:3000/authentications/auth'
      )

      if request['code'] == nil

        auth_uri = auth_client.authorization_uri({
          "include_granted_scopes" => "true",
          "access_type" => "offline",
          "prompt" => "consent"
        }).to_s
        byebug
        redirect_to auth_uri
      else
        byebug
        auth_client.code = request['code']
        auth_client.fetch_access_token!
        e = Encryptor.new
        byebug
        encrypted_data = e.encrypt(auth_client.client_secret)
        auth_client.client_secret = encrypted_data

        credentials = auth_client.to_json

        byebug
        current_user.update(provider: credentials)


        @api = api_call(current_user.uid, current_user.provider)

        # session.delete("credentials")

        # create_update_db(@api)

        redirect_to authentications_path


      end

  end

  def api_update
    view_id = current_user.uid
    auth = current_user.provider
    # client_secrets = Google::APIClient::ClientSecrets.load
    # auth_client = client_secrets.to_authorization

    if api_call(view_id, auth)
      flash[:notice] = "You have sucessfully update your data"
      redirect_to authentications_path
    else
      flash[:alert] = "Something is wrong, please try again later"
      render "authentications/show"
    end
  end

  def auto_update
    @users = User.all
    @users.each do |user|
      view_id = user.uid
      auth = user.provider
      api_call(view_id, auth)
    end
    redirect_to test_index_path
  end

  private

  def api_call(view_id, auth)
    byebug
    analytics = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
    credentials =  JSON.parse(auth)
    e = Encryptor.new
    byebug
    decrypt = e.decrypt(credentials["client_secret"])
    credentials["client_secret"] = decrypt
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

    response = analytics.batch_get_reports(request)

  end

  def create_update_db(data)

  end

end
