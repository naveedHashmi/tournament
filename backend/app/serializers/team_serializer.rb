class TeamSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :players
  belongs_to :captain, class_name: 'Player', foreign_key: 'captain_id'
end
