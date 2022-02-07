class AddChannelToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :channel, :uuid, null: false, default: "gen_random_uuid()"
  end
end
