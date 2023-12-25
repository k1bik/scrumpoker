class Room < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

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

  def last_game_played
    statistics["last_game_played"] || "No games yet"
  end

  def hidden_players
    User.joins(:user_room_estimates).where(user_room_estimates: {room: self, hidden: true})
  end

  def active_players
    User.joins(:user_room_estimates).where(user_room_estimates: {room: self, hidden: false})
  end

  def estimates_array
    estimates.split(UserRoomEstimate::SEPARATOR)
  end

  def has_estimate_statistics?
    statistics.key?("estimates")
  end

  def estimate_statistics
    statistics["estimates"]
  end
end
