module Boards


  def self.leaderboard(name)
    Leaderboard.new(
      name,
      default_options,
      redis_connection: Redis.current
    )
  end


  def self.default_options
    Leaderboard::DEFAULT_OPTIONS.merge(
      page_size: 25
    )
  end

  class Base
    def leaderboard(name)
      @leaderboard ||= Boards.leaderboard(name)
    end
  end
end
