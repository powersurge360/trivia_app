class ChangeGamesQuestionsToGameQuestion < ActiveRecord::Migration[7.0]
  def change
    rename_table :games_questions, :game_questions
  end
end
