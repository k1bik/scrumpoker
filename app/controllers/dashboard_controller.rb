class DashboardController < ApplicationController
  def index
    @user_count = User.count
    @room_count = Room.count
    @total_games_played = Room.total_games_played
  end
end
