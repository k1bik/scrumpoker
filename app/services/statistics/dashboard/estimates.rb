module Statistics
  module Dashboard
    class Estimates  
      def call
        input_array = ::Room.pluck(:statistics).pluck("estimates")

        result_hash = {}

        input_array.each do |hash|
          hash.each do |key, value|
            result_hash[key] ||= 0
            result_hash[key] += value
          end
        end

        result_hash
      end
    end
  end
end
