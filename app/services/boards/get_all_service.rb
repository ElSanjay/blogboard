module Boards
  class GetAllService < Boards::Base
    def execute(options = {})
      
      leaderboard(options[:name]).leaders(
        page(options).to_i,
        page_size: page_size(options),
        with_member_data: true
      )
    end

    private

    def page(options)
      options[:page] || 1
    end

    def page_size(options)
      options[:limit] || 10
    end
  end
end
