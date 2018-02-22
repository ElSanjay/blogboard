class LeaderboardPage
  include Capybara::DSL
  
  def visit_page
    visit("/leaderboards")
  end

end
