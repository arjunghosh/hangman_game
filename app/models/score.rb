class Score < ApplicationRecord
  validates :player_name, presence: true
  validates :points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
