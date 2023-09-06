class Api::TeamsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    teams = Team.includes(:captain).all

    render json: teams, include: %w[captain], status: :ok
  end

  def show
    render json: Team.includes(:captain, :players).find(params[:id]), include: %w[captain players], status: :ok
  end

  def create
    ActiveRecord::Base.transaction do
      team = Team.new(team_params.merge(gif_url: GiphyService.get_gif(team_params['name'])))

      if team.save!
        captain = Player.new(captain_params.merge(team: team))

        if captain.save!
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
    params.require(:data).require(:team).permit(:name)
  end

  def captain_params
    params.require(:data).require(:captain).permit(:fname, :lname)
  end
end
