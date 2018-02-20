class LeaderboardsController < ApplicationController
  # before_action :query_options

  def show
    @lb = Boards.leaderboard("mainboard")

    @entries = entry_service.execute(query_options("mainboard"))

    respond_to do |format|
      format.html do
        paginate(query_options("mainboard"))
      end

    end
  end

  def show_organic

    @lb = Boards.leaderboard("organic_search")
    @entries = entry_service.execute(query_options("organic_search"))

    respond_to do |format|
      format.html do
        paginate(query_options("organic_search"))
      end
    end

  end

  def show_social

    @lb = Boards.leaderboard("social")
    @entries = entry_service.execute(query_options("social"))

    respond_to do |format|
      format.html do
        paginate(query_options("social"))
      end
    end

  end

  def show_email

    @lb = Boards.leaderboard("email")
    @entries = entry_service.execute(query_options("email"))

    respond_to do |format|
      format.html do
        paginate(query_options("email"))
      end
    end

  end

  def show_direct

    @lb = Boards.leaderboard("direct")
    @entries = entry_service.execute(query_options("direct"))

    respond_to do |format|
      format.html do
        paginate(query_options("direct"))
      end
    end

  end

  def show_paid

    @lb = Boards.leaderboard("paid")
    @entries = entry_service.execute(query_options("paid"))

    respond_to do |format|
      format.html do
        paginate(query_options("paid"))
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
