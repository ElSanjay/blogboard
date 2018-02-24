class AuthPage
  include Capybara::DSL

  def connect_analytics(view_id)
    # visit("/authentications")
    fill_in("view_id", with: view_id)
    click_on "Update"
  end
end
