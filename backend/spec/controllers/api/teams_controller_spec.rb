require 'rails_helper'

RSpec.describe Api::TeamsController, type: :controller do
  describe 'GET #index' do
    it 'returns a JSON response with teams and their captains' do
      team = create(:team, name: 'Test Team')
      captain = create(:player, fname: 'John', lname: 'Doe', team: team)
      team.update(captain_id: captain.id)

      get :index

      expect(response).to have_http_status(:ok)

      expect(JSON.parse(response.body).length).to eq(1)

      team_data = JSON.parse(response.body).first
      expect(team_data['name']).to eq(team.name)

      captain_data = team_data['captain']
      expect(captain_data['id']).to eq(captain.id)
    end
  end

  describe 'GET #show' do
    it 'returns a JSON response with a specific team, its captain, and players' do
      team = create(:team, name: 'Test Team') # You should have a Team factory set up for this to work
      captain = create(:player, fname: 'John', lname: 'Doe', team: team) # You should have a Player factory set up for this to work
      player = create(:player, fname: 'Jane', lname: 'Smith', team: team) # You should have a Player factory set up for this to work
      team.update(captain_id: captain.id)

      get :show, params: { id: team.id }

      expect(response).to have_http_status(:ok)

      team_data = JSON.parse(response.body)
      expect(team_data['name']).to eq(team.name)

      captain_data = team_data['captain']
      expect(captain_data['id']).to eq(captain.id)

      players_data = team_data['players']
      expect(players_data.length).to eq(2)

      player_data = players_data.last
      expect(player_data['id']).to eq(player.id)
    end

    it 'returns a 404 status when the team does not exist' do
      get :show, params: { id: 999 }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      {
        data: {
          team: {
            name: 'New Team'
          },
          captain: {
            fname: 'John',
            lname: 'Doe'
          }
        }
      }
    end

    let(:invalid_attributes) do
      {
        data: {
          team: {
            name: ''
          },
          captain: {
            fname: 'John',
            lname: 'Doe'
          }
        }
      }
    end

    it 'creates a new team and its captain with valid attributes' do
      post :create, params: valid_attributes

      expect(response).to have_http_status(:created)
      expect(Team.count).to eq(1)
      expect(Player.count).to eq(1)

      team_data = JSON.parse(response.body)
      expect(team_data['name']).to eq('New Team')

      captain_data = team_data['captain']
      captain = Player.find(captain_data['id'])
      expect(captain.fname).to eq('John')
      expect(captain.lname).to eq('Doe')
    end

    it 'returns errors with invalid attributes' do
      post :create, params: invalid_attributes

      expect(response).to have_http_status(:unprocessable_entity)
      expect(Team.count).to eq(0)
      expect(Player.count).to eq(0)

      errors = JSON.parse(response.body)
      expect(errors["error"]).to include('Unprocessable Entity')
    end
  end
end
