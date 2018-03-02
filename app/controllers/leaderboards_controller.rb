class LeaderboardsController < ApplicationController
  before_action :check_page_params

  def show

    @lb = Boards.leaderboard("mainboard_#{params[:board]}")

    @entries = entry_service.execute(query_options("mainboard_#{params[:board]}"))
    respond_to do |format|
      format.html do
        paginate(query_options("mainboard_#{params[:board]}"))
      end

    end
  end

  def show_organic

    @lb = Boards.leaderboard("organic_search_#{params[:board]}")
    @entries = entry_service.execute(query_options("organic_search_#{params[:board]}"))

    respond_to do |format|
      format.html do
        paginate(query_options("organic_search_#{params[:board]}"))
      end
    end

  end

  def show_social

    @lb = Boards.leaderboard("social_#{params[:board]}")
    @entries = entry_service.execute(query_options("social_#{params[:board]}"))

    respond_to do |format|
      format.html do
        paginate(query_options("social_#{params[:board]}"))
      end
    end

  end

  def show_email

    @lb = Boards.leaderboard("email_#{params[:board]}")
    @entries = entry_service.execute(query_options("email_#{params[:board]}"))

    respond_to do |format|
      format.html do
        paginate(query_options("email_#{params[:board]}"))
      end
    end

  end

  def show_direct

    @lb = Boards.leaderboard("direct_#{params[:board]}")
    @entries = entry_service.execute(query_options("direct_#{params[:board]}"))

    respond_to do |format|
      format.html do
        paginate(query_options("direct_#{params[:board]}"))
      end
    end

  end

  def show_paid

    @lb = Boards.leaderboard("paid_#{params[:board]}")
    @entries = entry_service.execute(query_options("paid_#{params[:board]}"))

    respond_to do |format|
      format.html do
        paginate(query_options("paid_#{params[:board]}"))
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

def check_page_params
  @page = params[:page] || nil

  if @page
    @drop = 0
  else
    @drop = 1
  end
end




end
