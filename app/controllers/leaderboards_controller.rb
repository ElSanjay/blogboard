class LeaderboardsController < ApplicationController
  before_action :check_page_params

  def show

    board = "#{params[:board]}_#{params[:filter]}"
    @board_name = params[:board]
    @lb = Boards.leaderboard(board)

    @entries = entry_service.execute(query_options(board))

    respond_to do |format|
      format.html do
        paginate(query_options(board))
      end

    end


  end

  def custom_filter

    custom_api_call(params[:start_date].to_date.to_s, params[:end_date].to_date.to_s, params[:board])
    redirect_to leaderboards_path(board: params[:board], filter: "custom")
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

  def check_page_params
    @page = params[:page] || nil

    if @page
      @drop = 0
    else
      @drop = 1
    end
  end

  def custom_api_call(start_date, end_date, board_type)
    @users = User.all
    @users.each do |user|
      CustomApiCallJob.perform_later(user, start_date, end_date, board_type)
      # api = user.custom_api_call(start_date, end_date)
      # user.update_custom_leaderboard(api, board_type)
    end

  end


end
