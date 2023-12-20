class Room < ApplicationRecord
  NAME_LENGTH = 25
  GAME_PLAYED_KEY = "games_played"

  scope :with_games_played, -> { where.not("statistics -> '#{GAME_PLAYED_KEY}' IS NULL") }

  belongs_to :owner, class_name: "User", required: true
  has_many :users
  has_many :user_room_estimates, dependent: :destroy
  has_many :users, through: :user_room_estimates

  validates :name, :estimates, presence: true
  validates :name, length: { maximum: NAME_LENGTH }
  validates :estimates, format: { with: /\A(?:[^,]+,)*[^,]+\z/, message: "должны быть разделены запятыми" }

  def self.total_games_played
    with_games_played.sum("CAST(statistics ->> '#{GAME_PLAYED_KEY}' AS INTEGER)")
  end

  def total_games
    statistics[GAME_PLAYED_KEY]
  end
end
