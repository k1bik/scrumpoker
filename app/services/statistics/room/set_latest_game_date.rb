module Statistics
  module Room
    class SetLatestGameDate
      LAST_GAME_PLAYED_KEY = "last_game_played"

      def initialize(room)
        @room = room
      end
  
      def call
        last_game_played = @room.statistics[LAST_GAME_PLAYED_KEY]
        date_today = Date.current.strftime("%d.%m.%Y")
 
        return if last_game_played == date_today

        @room.statistics[LAST_GAME_PLAYED_KEY] = date_today
        @room.save
      end
    end
  end
end
