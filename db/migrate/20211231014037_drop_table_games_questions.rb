class DropTableGamesQuestions < ActiveRecord::Migration[7.0]
  def change
    drop_table :games_questions
  end
end
