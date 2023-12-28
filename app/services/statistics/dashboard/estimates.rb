module Statistics
  module Dashboard
    class Estimates  
      def call
        estimates_array = ::Room.pluck(:statistics).pluck(::Room::ESTIMATES_KEY).compact
        result_hash = {}

        estimates_array.each do |hash|
          hash.each do |key, value|
            result_hash[key] ||= 0
            result_hash[key] += value
          end
        end

        result_hash.sort_by { |_, value| -value }
      end
    end
  end
end
