class TestController < ApplicationController
  require 'google/api_client/client_secrets'
  
  def index
    client_secrets = ENV['GOOGLE_CLIENT_SECRET']
    byebug
    auth_client = client_secrets.to_authorization
    byebug
    auth_client.update!(
      :scope => 'https://www.googleapis.com/auth/drive.metadata.readonly',
      :redirect_uri => 'http://www.example.com/oauth2callback',
      :additional_parameters => {
        "access_type" => "offline",         # offline access
        "include_granted_scopes" => "true"  # incremental auth
      }
    )
  end

end
