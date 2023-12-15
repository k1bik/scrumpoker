class DashboardController < ApplicationController
  def index
    @user_count = User.count
    @room_count = Room.count
  end
end
