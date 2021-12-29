class AddErrorMessageToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :error_message, :string
  end
end
