class AddIndexToTeamsOnName < ActiveRecord::Migration[6.0]
  def change
    add_index :teams, 'LOWER(name)', unique: true
  end
end
