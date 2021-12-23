class CreateJoinTableGamesQuestions < ActiveRecord::Migration[7.0]
  def change
    create_join_table :games, :questions do |t|
      t.index [:game_id, :question_id]
      t.index [:question_id, :game_id]
    end
  end
end
