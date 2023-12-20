class UserRoomsController < ApplicationController
  def update
    UserRoom.find(params["user_room_id"]).update(estimate: params["estimate"])
  end
end
