class LeaderboardsController < ApplicationController
  before_action :query_options

  def show
    @lb = Boards.default_leaderboard

    @entries = entry_service.execute(query_options)

    respond_to do |format|
      format.html do
        paginate(query_options)
      end

    end
  end

  private

  def entry_service
    Boards::GetAllService.new
  end

  def paginate(options = {})
      pager = Kaminari.paginate_array(
        @entries,
        total_count: @lb.total_members)
      @page_array = pager.page(options[:page]).per(options[:limit])
      
    end




end
