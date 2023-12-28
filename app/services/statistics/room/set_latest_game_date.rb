module Statistics
  module Room
    class SetLatestGameDate
      def initialize(room)
        @room = room
      end
  
      def call
        last_game_played = @room.statistics[::Room::LAST_GAME_PLAYED_KEY]
        date_today = Date.current.strftime(DATE_FORMAT)
 
        return if last_game_played == date_today

        @room.statistics[::Room::LAST_GAME_PLAYED_KEY] = date_today
      end
    end
  end
end
