class LoginPage
  include Capybara::DSL

  def authenticate

    visit("/")
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({

       :provider => 'google_oauth2',
       :uid => '123545',
       :info => {
         :name => 'mockuser',
         :email => 'mockemail@test.com',
         :imgage => 'image'
       },
       :credentials => {
          :token => "TOKEN",
          :refresh_token => "REFRESH_TOKEN",
          :expires_at => 1496120719,
          :expires => true
        },
       # etc.
   })

		click_on("Authenticate")

  end

end
