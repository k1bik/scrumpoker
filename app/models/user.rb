class User < ApplicationRecord
  has_secure_password

  NICKNAME_LENGTH = 25

  has_many :rooms, foreign_key: :owner_id
  has_many :user_rooms
  has_many :rooms, through: :user_rooms

  validates :nickname, :password_digest, presence: true
  validates :nickname, uniqueness: true
  validates :nickname, length: { maximum: NICKNAME_LENGTH }
end
