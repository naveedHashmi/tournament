require 'rails_helper'

RSpec.describe TeamSerializer do
  let(:team) { create(:team, name: 'Test Team', gif_url: 'https://example.com/test.gif') }
  let(:captain) { create(:player, fname: 'John', lname: 'Doe', team: team) }
  let(:players) { create_list(:player, 3, team: team) }

  before do
    team.update(captain_id: captain.id, players: players)
  end

  subject { described_class.new(team).as_json }

  it 'serializes the team attributes' do
    expect(subject[:id]).to eq(team.id)
    expect(subject[:name]).to eq('Test Team')
    expect(subject[:gif_url]).to eq('https://example.com/test.gif')
  end

  it 'serializes the captain association' do
    expect(subject[:captain]).to eq({
      id: captain.id,
      fname: 'John',
      lname: 'Doe'
    })
  end

  it 'serializes the players association' do
    expect(subject[:players].count).to eq(3)

    subject[:players].each_with_index do |player, index|
      expect(player).to eq({
        id: players[index].id,
        fname: players[index].fname,
        lname: players[index].lname
      })
    end
  end
end
