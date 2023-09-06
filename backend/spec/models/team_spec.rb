require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'validations' do
    subject { create(:team) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_numericality_of(:captain_id).allow_nil }
  end

  describe 'associations' do
    it { should belong_to(:captain).class_name('Player').with_foreign_key('captain_id').optional(true) }
    it { should have_many(:players) }
  end
end
