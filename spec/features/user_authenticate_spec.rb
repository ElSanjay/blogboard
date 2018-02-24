require 'rails_helper'
require_relative '../support/login_page'
require_relative '../support/auth_page'
require_relative '../support/leaderboard_page'

RSpec.describe 'User update data', type: :feature do
  include ActiveJob::TestHelper
  after do
    clear_enqueued_jobs
  end

  let(:login_page) {LoginPage.new}
  let(:auth_page) {AuthPage.new}
  let(:leaderboard_page) {LeaderboardPage.new}

  scenario 'authenticate with google' do
    login_page.authenticate
    expect(User.first.provider).to eq("google_oauth2")
    expect(page).to have_content("View ID")

  end

  scenario 'get data from api' do

    login_page.authenticate
    expect {
      auth_page.connect_analytics("12345")
    }.to have_enqueued_job(UserApiCallJob)
  end

  scenario 'email sent after connected to analytic' do

    login_page.authenticate

    perform_enqueued_jobs {
      auth_page.connect_analytics("12345")

    }

      expect(UserConnectedMailer.deliveries.count).to eq 1

  end

  scenario 'email will not be sent after connected to analytic for existing user' do

    login_page.authenticate

    perform_enqueued_jobs {
      auth_page.connect_analytics("12345")

    }
    perform_enqueued_jobs {
      auth_page.connect_analytics("12345")

    }

      expect(UserConnectedMailer.deliveries.count).not_to eq 1

  end


  scenario 'update database ' do
    login_page.authenticate

    perform_enqueued_jobs {
      auth_page.connect_analytics("12345")
    }

    expect(User.first.data).not_to be_nil
  end

  scenario 'update leaderboard ' do

    login_page.authenticate
    perform_enqueued_jobs do
      auth_page.connect_analytics("12345")
    end

    leaderboard_page.visit_page
    expect(page).to have_content(User.first.name)
  end




end
