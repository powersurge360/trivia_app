class AddCorrectlyAnsweredToGamesQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :games_questions, :correctly_answered, :boolean
  end
end
