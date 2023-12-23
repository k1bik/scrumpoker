class UserRoomEstimate < ApplicationRecord
  SEPARATOR = ","

  belongs_to :user
  belongs_to :room
end
