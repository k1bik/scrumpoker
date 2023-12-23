class ApplicationController < ActionController::Base
  helper_method :current_user, :sign_in?

  def update_turbo(channel:, partial:, locals:, target:)
    Turbo::StreamsChannel.broadcast_update_to(channel, partial:, locals:, target:)
  end

  def update_estimate_table(room:)
    update_turbo(
      channel: "room_#{room.id}",
      partial: "rooms/estimate_table",
      locals: { players: room.users, room: },
      target: "estimate_table_room_#{room.id}"
    )
  end

  private

  def sign_in?
    current_user.present?
  end

  def authenticate_user
    return if current_user

    redirect_to new_session_path
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
