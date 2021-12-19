class ChangeCorrectAnswerToString < ActiveRecord::Migration[7.0]
  def change
    change_column :questions, :correct_answer, :string
  end
end
