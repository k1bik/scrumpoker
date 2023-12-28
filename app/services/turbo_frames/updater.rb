module TurboFrames
  class Updater
    def initialize(room, current_user)
      @room = room
      @current_user = current_user
    end

    def room_estimates
      update_turbo(
        channel: "room_#{@room.id}",
        partial: "rooms/estimates",
        locals: { estimates: @room.estimates_array, room_id: @room.id, current_user: @current_user },
        target: "room_estimates_#{@room.id}"
      )
    end

    def room_actions
      update_turbo(
        channel: "room_#{@room.id}",
        partial: "rooms/actions",
        locals: { room: @room },
        target: "room_actions_#{@room.id}"
      )
    end

    def estimate_table
      update_turbo(
        channel: "room_#{@room.id}",
        partial: "rooms/estimate_table",
        locals: { players: @room.active_players, room: @room },
        target: "estimate_table_room_#{@room.id}"
      )
    end

    def room_statistics
      update_turbo(
        channel: "room_#{@room.id}",
        partial: "rooms/statistics",
        locals: { room: @room },
        target: "room_statistics_#{@room.id}"
      )
    end

    def user_estimate(current_user_estimate)
      update_turbo(
        channel: "room_#{@room.id}",
        partial: "rooms/user_estimate",
        locals: { user_room_estimate: current_user_estimate },
        target: "estimate_user_#{@current_user.id}_room_#{@room.id}"
      )
    end

    private

    def update_turbo(channel:, partial:, locals:, target:)
      Turbo::StreamsChannel.broadcast_update_to(channel, partial:, locals:, target:)
    end
  end
end
