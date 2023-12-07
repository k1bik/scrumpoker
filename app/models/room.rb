class Room < ApplicationRecord
  belongs_to :owner, class_name: "User", required: true

  validates :name, :estimates, presence: true
end
