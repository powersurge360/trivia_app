class RemoveQuestionIdsFromGame < ActiveRecord::Migration[7.0]
  def change
    remove_column :games, :question_ids
  end
end
