class AddDifficultyToQuestion < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :difficulty, :string, default: "easy", null: false
  end
end
