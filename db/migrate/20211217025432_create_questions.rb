class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions, id: :string do |t|
      t.text :body, null: false
      t.string :answer_1, null: false
      t.string :answer_2, null: false
      t.string :answer_3, null: true
      t.string :answer_4, null: true
      t.integer :correct_answer, null: false

      t.timestamps
    end
  end
end
