class DashboardController < ApplicationController
  def index
    authenticate_user

    @user_count = User.count
    @room_count = Room.count
    @total_games_played = Room.total_games_played
    @estimates_hash = Statistics::Dashboard::Estimates.new.call
  end
end
