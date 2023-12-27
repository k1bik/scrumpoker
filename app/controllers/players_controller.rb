class PlayersController < ApplicationController
  def index
    @room = Room.friendly.find(params[:room_id])
    @players = @room.users.includes(:user_room_estimates)
  end

  def hide
    user = User.find(params[:player_id])
    room = Room.friendly.find(params[:room_id])
    user_room_estimate = UserRoomEstimate.find_by(user:, room:)
    user_room_estimate.update(hidden: true)
    TurboFrames::Updater.new(room, current_user).estimate_table

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          :room_players,
          partial: "players/table",
          locals: { room: }
        )
      end
    end
  end

  def unhide
    user = User.find(params[:player_id])
    room = Room.friendly.find(params[:room_id])
    user_room_estimate = UserRoomEstimate.find_by(user:, room:)
    user_room_estimate.update(hidden: false)
    TurboFrames::Updater.new(room, current_user).estimate_table

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          :room_players,
          partial: "players/table",
          locals: { room: }
        )
      end
    end
  end
end
