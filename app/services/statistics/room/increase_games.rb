module Statistics
  module Room
    class IncreaseGames
      GAME_PLAYED_KEY = "games_played"

      def initialize(room)
        @room = room
      end
  
      def call
        if @room.statistics[GAME_PLAYED_KEY].present?
          @room.statistics[GAME_PLAYED_KEY] += 1
        else
          @room.statistics[GAME_PLAYED_KEY] = 1
        end
        @room.save
      end
    end
  end
end
