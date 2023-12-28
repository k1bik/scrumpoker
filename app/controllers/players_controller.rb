class PlayersController < ApplicationController
  def index
    @room = Room.friendly.find(params[:room_id])

    redirect_to room_path(@room) unless current_user == @room.owner

    @players = @room.users.includes(:user_room_estimates)
  end

  def toggle_visibility
    user = User.find(params[:player_id])
    room = Room.friendly.find(params[:room_id])
    user_room_estimate = UserRoomEstimate.find_by(user:, room:)
    value = ActiveModel::Type::Boolean.new.cast(params[:value])
    return if user_room_estimate.is_hidden == value

    user_room_estimate.update(is_hidden: value)
    TurboFrames::Updater.new(room, current_user).estimate_table

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(:room_players, partial: "players/table", locals: { room: })
      end
    end
  end
end
