class Player < ApplicationRecord
  validates :fname, :lname, presence: true
end
