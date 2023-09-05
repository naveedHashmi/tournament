class Player < ApplicationRecord
  belongs_to :team, optional: true

  validates :fname, :lname, presence: true
end
