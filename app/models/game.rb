class Game < ApplicationRecord
  has_and_belongs_to_many :questions

  validates :difficulty, inclusion: [nil, 'easy', 'medium', 'hard']
  validates :number_of_questions, numericality: { greater_than: 0, less_than_or_equal_to: 50 }
  validates :category, inclusion: TRIVIA_CATEGORIES.keys
  validates :game_type, inclusion: [nil, 'boolean', 'multiple']

  def retrieve_questions
  end
end
