require 'rails_helper'

RSpec.describe Player, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:fname) }
    it { should validate_presence_of(:lname) }
  end

  describe 'associations' do
    it { should belong_to(:team) }
  end
end
