class ChangeDefaultGameTypeOnGames < ActiveRecord::Migration[7.0]
  def change
    change_column :games, :game_type, :string, null: false, default: ''
  end
end
