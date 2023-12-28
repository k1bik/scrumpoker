module Statistics
  module Room
    class IncreaseGames
      def initialize(room)
        @room = room
      end
  
      def call
        @room.statistics[::Room::GAME_PLAYED_KEY] ||= 0
        @room.statistics[::Room::GAME_PLAYED_KEY] += 1
      end
    end
  end
end
