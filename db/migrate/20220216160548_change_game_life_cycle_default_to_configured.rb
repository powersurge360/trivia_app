class ChangeGameLifeCycleDefaultToConfigured < ActiveRecord::Migration[7.0]
  def change
    change_column :games, :game_lifecycle, :string, default: "configured"
  end
end
