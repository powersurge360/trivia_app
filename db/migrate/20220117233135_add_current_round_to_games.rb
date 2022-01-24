class AddCurrentRoundToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :current_round, :integer, default: 1, null: false
  end
end
