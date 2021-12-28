class ChangeNumberOfQuestionsOnGame < ActiveRecord::Migration[7.0]
  def change
    change_column :games, :number_of_questions, :integer, null: false, default: 10
  end
end
