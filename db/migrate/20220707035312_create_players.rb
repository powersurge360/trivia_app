class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.uuid :channel
      t.string :username

      t.timestamps
    end

    add_index :players, [:channel, :username], unique: true
  end
end
