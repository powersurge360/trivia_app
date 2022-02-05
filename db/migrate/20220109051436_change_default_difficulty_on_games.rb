class ChangeDefaultDifficultyOnGames < ActiveRecord::Migration[7.0]
  def change
    change_column :games, :difficulty, :string, null: false, default: ""
  end
end
