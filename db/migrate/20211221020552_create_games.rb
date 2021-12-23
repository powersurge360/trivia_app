class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.integer :number_of_questions, default: 10
      t.integer :category
      t.string :difficulty
      t.string :game_type
      t.string :session_token
      t.string :game_lifecycle, default: "pending", null: false
      t.string :question_ids, array: true

      t.timestamps
    end
  end
end
