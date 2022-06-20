class AddJoinCodeAndGameModeToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :join_code, :string
    add_column :games, :game_mode, :string, default: "single", null: false
  end
end
