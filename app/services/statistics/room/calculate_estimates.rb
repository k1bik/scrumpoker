module Statistics
  module Room
    class CalculateEstimates
      def initialize(room)
        @room = room
      end
  
      def call
        user_room_estimates = @room.user_room_estimates.where(user: @room.active_players)
        estimates_array = user_room_estimates.pluck(:value).compact

        estimates_hash = @room.statistics.fetch(::Room::ESTIMATES_KEY, {})
        estimates_array.each do |estimate|
          estimates_hash[estimate] = estimates_hash.fetch(estimate, 0) + 1
        end

        @room.statistics[::Room::ESTIMATES_KEY] = estimates_hash
      end
    end
  end
end
