class AddHostToPlayer < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :host, :boolean, null: false, default: false
  end
end
