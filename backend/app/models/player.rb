class Player < ApplicationRecord
  belongs_to :team

  validates :fname, :lname, presence: true
end
