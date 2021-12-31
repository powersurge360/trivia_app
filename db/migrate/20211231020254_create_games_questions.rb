class CreateGamesQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :games_questions do |t|
      t.references :game, index: true
      t.references :question, type: :string, index: true
    end
  end
end
