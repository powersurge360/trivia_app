class UpdateForeignKeyOnGamesQuestions < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :games_questions, :games
    add_foreign_key :games_questions, :questions
  end
end
