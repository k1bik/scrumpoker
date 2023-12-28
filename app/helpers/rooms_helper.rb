module RoomsHelper
  def user_room_estimate(user, room)
    UserRoomEstimate.find_by(user:, room:)
  end
end
