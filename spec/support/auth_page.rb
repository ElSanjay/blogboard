class AuthPage
  include Capybara::DSL
  def connect_analytics(view_id)

    fill_in("view_id", with: view_id)
    click_on "Connect"
  end
end
