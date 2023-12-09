class Room < ApplicationRecord
  NAME_LENGTH = 25

  belongs_to :owner, class_name: "User", required: true
  has_many :users
  has_many :user_rooms
  has_many :users, through: :user_rooms

  validates :name, :estimates, presence: true
  validates :name, length: { maximum: NAME_LENGTH }
  validates :estimates, format: { with: /\A(?:[^,]+,)*[^,]+\z/, message: "должны быть разделены запятыми" }
end
