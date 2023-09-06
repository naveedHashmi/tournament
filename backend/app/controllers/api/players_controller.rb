class Api::PlayersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    players = Player.includes(:team).all

    render json: players, include: %w[team], status: :ok
  end

  def create
    player = Player.new(player_params)

    if player.save
      render json: player, include: %[team], status: :created
    else
      render json: player.errors, status: :unprocessable_entity
    end
  end

  private

  def player_params
    params.require(:data).require(:player).permit(:fname, :lname, :team_id)
  end
end
