class Team < ApplicationRecord
  belongs_to :captain, class_name: 'Player', foreign_key: 'captain_id'

  has_many :players

  validates :name, presence: true
  validates :captain_id, presence: true, numericality: true
end
