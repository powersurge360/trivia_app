class ChangeGameModeToPlayerMode < ActiveRecord::Migration[7.0]
  def change
    rename_column :games, :game_mode, :player_mode
  end
end
