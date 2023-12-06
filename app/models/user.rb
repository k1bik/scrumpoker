class User < ApplicationRecord
  has_secure_password

  validates :nickname, :password_digest, presence: true
  validates :nickname, uniqueness: true
end
