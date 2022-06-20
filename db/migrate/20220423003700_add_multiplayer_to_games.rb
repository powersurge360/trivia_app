class AddMultiplayerToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :multiplayer, :boolean, null: false, default: false
  end
end
