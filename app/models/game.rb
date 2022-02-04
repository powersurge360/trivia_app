class Game < ApplicationRecord
  include AASM

  has_many :game_questions
  has_many :questions, through: :game_questions

  validates :difficulty, inclusion: DIFFICULTY_CHOICES.values
  validates :number_of_questions, numericality: { greater_than: 0, less_than_or_equal_to: 50 }
  validates :category, inclusion: TRIVIA_CATEGORIES.values
  validates :game_type, inclusion: GAME_TYPES.values

  aasm column: :game_lifecycle do
    state :pending, initial: true
    state :error
    state :ready
    state :running
    state :answered
    state :finished

    event :finished_setup do
      transitions from: :pending, to: :ready
    end

    event :error_detected do
      transitions from: :pending, to: :error
    end

    event :start do
      transitions from: :ready, to: :running
    end

    event :answer do
      before do |*args|
        answer_with(*args)
      end

      transitions from: :running, to: :answered
    end

    event :continue do
      transitions from: :answered, to: :running
    end

    event :finish do
      transitions from: :answered, to: :finished
    end
  end

  broadcasts

  def current_question
    if current_round > number_of_questions
      return nil
    end

    questions.offset(current_round - 1).limit(1).first
  end

  def current_answer
    GameQuestion.find_by(game: self, question: current_question)
  end

  def retrieve_trivia_questions
    RetrieveTriviaQuestionsJob.perform_later(self)
  end

  def answer_with(answer)
    game_relation = GameQuestion.find_by(question: current_question.id, game: id)

    if answer == current_question.correct_answer
      game_relation.update(correctly_answered: true)
    else
      game_relation.update(correctly_answered: false)
    end
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
      type: attrs['game_type']
    }
  end
end
