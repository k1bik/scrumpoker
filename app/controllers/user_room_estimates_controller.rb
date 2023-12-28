class UserRoomEstimatesController < ApplicationController
  def set_estimate
    current_user_estimate = UserRoomEstimate.find_by(room_id: params[:room_id], user: current_user)
    user_estimate = params["estimate"]
    return if current_user_estimate.value == user_estimate
    
    room = current_user_estimate.room
    current_user_estimate.update(value: user_estimate)
    TurboFrames::Updater.new(room, current_user).user_estimate(current_user_estimate)

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

    ActiveRecord::Base.transaction do
      room.update(is_estimates_hidden: true)
      room.user_room_estimates.each { |estimate| estimate.update(value: nil) }
    end

    updater = TurboFrames::Updater.new(room, current_user)
    updater.room_estimates
    updater.room_actions
    updater.estimate_table
  end

  def show_estimates
    room = Room.find(params[:room_id])
    room.update(is_estimates_hidden: false)

    ActiveRecord::Base.transaction do
      Statistics::Room::IncreaseGames.new(room).call
      Statistics::Room::CalculateEstimates.new(room).call
      Statistics::Room::SetLatestGameDate.new(room).call
      room.save
    end

    updater = TurboFrames::Updater.new(room, current_user)
    updater.room_statistics
    updater.room_actions
    updater.estimate_table
  end

  def hide_estimates
    room = Room.find(params[:room_id])
    room.update(is_estimates_hidden: true)
    updater = TurboFrames::Updater.new(room, current_user)
    updater.estimate_table
    updater.room_actions
  end
end
