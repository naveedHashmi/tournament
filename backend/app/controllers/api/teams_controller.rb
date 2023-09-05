class Api::TeamsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    teams = Team.includes(:captain).all

    render json: teams, include: %w[captain], status: :ok
  end

  def create
    ActiveRecord::Base.transaction do
      team = Team.new(team_params)

      if team.save
        captain = Player.new(captain_params.merge(team: team))

        if captain.save
          team.update(captain_id: captain.id)

          render json: team, include: %w[captain], status: :created
        else
          render json: captain.errors, status: :unprocessable_entity
          raise ActiveRecord::Rollback # Rollback the transaction if captain creation fails
        end
      else
        render json: team.errors, status: :unprocessable_entity
      end
    end
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end

  def captain_params
    params.require(:captain).permit(:fname, :lname)
  end
end
