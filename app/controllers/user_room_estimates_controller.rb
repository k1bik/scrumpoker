class UserRoomEstimatesController < ApplicationController
  def update
    current_user_estimate = UserRoomEstimate.find_by(room_id: params[:room_id], user: current_user)
    user_estimate = params["estimate"]
    room = current_user_estimate.room
    return if current_user_estimate.value == user_estimate
 
    current_user_estimate.update(value: user_estimate)

    update_turbo(
      channel: "room_#{room.id}",
      partial: "rooms/user_estimate",
      locals: { user_room_estimate: current_user_estimate },
      target: "estimate_user_#{current_user.id}_room_#{room.id}"
    )

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "room_estimates_#{room.id}",
          partial: "rooms/estimates",
          locals: { estimates: room.estimates_array, room_id: room.id }
        )
      end
    end
  end

  def clear_all
    room = Room.find(params[:room_id])
    room.update(is_estimates_hidden: true)
    room.user_room_estimates.each { |estimate| estimate.update(value: nil) }
    update_estimate_table(room:)
    update_turbo(
      channel: "room_#{room.id}",
      partial: "rooms/estimates",
      locals: { estimates: room.estimates_array, room_id: room.id, current_user: },
      target: "room_estimates_#{room.id}"
    )
    update_turbo(
      channel: "room_#{room.id}",
      partial: "rooms/actions",
      locals: { room: },
      target: "room_actions_#{room.id}"
    )
  end

  def show_estimates
    room = Room.find(params[:room_id])
    room.update(is_estimates_hidden: false)

    ActiveRecord::Base.transaction do
      Statistics::Room::IncreaseGames.new(room).call
      Statistics::Room::CalculateEstimates.new(room).call
      Statistics::Room::SetLatestGameDate.new(room).call
    end

    update_estimate_table(room:)

    update_turbo(
      channel: "room_#{room.id}",
      partial: "rooms/actions",
      locals: { room: },
      target: "room_actions_#{room.id}"
    )

    update_turbo(
      channel: "room_#{room.id}",
      partial: "rooms/statistics",
      locals: { room: },
      target: "room_statistics_#{room.id}"
    )
  end

  def hide_estimates
    room = Room.find(params[:room_id])
    room.update(is_estimates_hidden: true)
    update_estimate_table(room:)
    update_turbo(
      channel: "room_#{room.id}",
      partial: "rooms/actions",
      locals: { room: },
      target: "room_actions_#{room.id}"
    )
  end
end
