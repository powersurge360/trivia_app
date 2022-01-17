class Game < ApplicationRecord
  has_and_belongs_to_many :questions

  validates :difficulty, inclusion: DIFFICULTY_CHOICES.values
  validates :number_of_questions, numericality: { greater_than: 0, less_than_or_equal_to: 50 }
  validates :category, inclusion: TRIVIA_CATEGORIES.values
  validates :game_type, inclusion: GAME_TYPES.values

  def retrieve_trivia_questions
    RetrieveTriviaQuestionsJob.perform_later(self)
  end

  def api_attributes
    attrs = self.attributes.slice(
      'difficulty',
      'number_of_questions',
      'category',
      'game_type',
    )

    {
      difficulty: attrs['difficulty'],
      amount: attrs['number_of_questions'],
      category: attrs['category'],
      game_type: attrs['game_type']
    }
  end
end
