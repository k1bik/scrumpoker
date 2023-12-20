class UserRoomEstimateEstimatesController < ApplicationController
  def update
    UserRoomEstimate.find(params["user_room_id"]).update(estimate: params["estimate"])
  end
end
