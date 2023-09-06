class Team < ApplicationRecord
  belongs_to :captain, class_name: 'Player', foreign_key: 'captain_id', optional: true

  has_many :players

  validates :name, presence: true, uniqueness: true
  validates :captain_id, allow_nil: true, numericality: true
end
