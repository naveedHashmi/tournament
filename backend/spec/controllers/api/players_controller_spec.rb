require 'rails_helper'

RSpec.describe Api::PlayersController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'returns JSON with players and their teams' do
      team = create(:team)
      player = create(:player, team: team)
      get :index
      json_response = JSON.parse(response.body)

      expect(json_response[0]['id']).to eq(player.id)
      expect(json_response[0]['team']['id']).to eq(team.id)
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { data: { player: { fname: 'John', lname: 'Doe', team_id: create(:team).id } } } }
    let(:invalid_params) { { data: { player: { fname: '', lname: '', team_id: nil } } } }

    context 'with valid parameters' do
      it 'creates a new player' do
        expect do
          post :create, params: valid_params
        end.to change(Player, :count).by(1)
      end

      it 'returns a successful response' do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
      end

      it 'returns JSON with the created player and its team' do
        post :create, params: valid_params
        json_response = JSON.parse(response.body)

        expect(json_response['fname']).to eq('John')
        expect(json_response['team']).to be_present
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new player' do
        expect do
          post :create, params: invalid_params
        end.to_not change(Player, :count)
      end

      it 'returns unprocessable entity status' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns JSON with errors' do
        post :create, params: invalid_params
        json_response = JSON.parse(response.body)

        expect(json_response).to eq({"fname"=>["can't be blank"], "lname"=>["can't be blank"], "team"=>["must exist"]})
      end
    end
  end
end
