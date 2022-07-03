class RemoveJoinCodeFromGame < ActiveRecord::Migration[7.0]
  def change
    remove_column :games, :join_code, :string
  end
end
