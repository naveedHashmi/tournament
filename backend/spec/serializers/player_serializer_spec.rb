require 'rails_helper'

RSpec.describe PlayerSerializer do
  let(:team) { create(:team, name: 'Test Team') }
  let(:player) { create(:player, fname: 'John', lname: 'Doe', team: team) }

  subject { described_class.new(player).as_json }

  it 'serializes the player attributes' do
    expect(subject[:id]).to eq(player.id)
    expect(subject[:fname]).to eq('John')
    expect(subject[:lname]).to eq('Doe')
  end

  it 'serializes the team association' do
    expect(subject[:team]).to eq({
      id: team.id,
      name: 'Test Team',
      gif_url: team.gif_url
    })
  end
end
