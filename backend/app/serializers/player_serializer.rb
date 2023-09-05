class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :fname, :lname
  belongs_to :team
end
