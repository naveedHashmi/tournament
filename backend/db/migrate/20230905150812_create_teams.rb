class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams do |t|
      t.string :name, default: '', null: false

      t.timestamps
    end
  end
end
