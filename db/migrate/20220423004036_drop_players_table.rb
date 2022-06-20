class DropPlayersTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :players
  end
end
