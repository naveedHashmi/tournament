class AddGifUrlInTeam < ActiveRecord::Migration[6.0]
  def change
    add_column :teams, :gif_url, :string, default: ''
  end
end
