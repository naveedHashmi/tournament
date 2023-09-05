class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.string :fname, default: '', null: false
      t.string :lname, default: '', null: false

      t.timestamps
    end
  end
end
