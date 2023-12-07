class User < ApplicationRecord
  has_secure_password

  has_many :rooms, foreign_key: :owner_id

  validates :nickname, :password_digest, presence: true
  validates :nickname, uniqueness: true
end
