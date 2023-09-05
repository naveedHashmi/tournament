class AddTeamPlayerAssocations < ActiveRecord::Migration[6.0]
  def change
    add_column :players, :team_id, :integer
    add_column :teams, :captain_id, :integer

    add_foreign_key :players, :teams, column: :team_id
  end
end
