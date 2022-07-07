class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.uuid :channel
      t.string :username

      t.timestamps
    end
  end
end
