module Boards
  class UpdateService < Boards::Base
    def execute(entry_params)
      name = entry_params[:name]
      score = entry_params[:score].to_i
      id = entry_params[:id]
      data = {
        organic: entry_params[:organic],
        social: entry_params[:social],
        email: entry_params[:email],
        direct: entry_params[:direct],
        paid: entry_params[:paid]
      }

      leaderboard.rank_member(name, score, {
        id: id,
        data: {
          organic: data[:organic],
          social: data[:social],
          email: data[:email],
          direct: data[:direct],
          paid: data[:paid],
        }
      }.to_json)
      member = leaderboard.score_and_rank_for(name)
      member[:page] = leaderboard.page_for(name, leaderboard.page_size)
      member
    end
  end
end
