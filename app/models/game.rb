class Game < ApplicationRecord
  include AASM

  # Relationships

  has_many :game_questions
  has_many :questions, through: :game_questions

  # Validation

  validates :difficulty, inclusion: DIFFICULTY_CHOICES.values
  validates :number_of_questions, numericality: {greater_than: 0, less_than_or_equal_to: 50}
  validates :category, inclusion: TRIVIA_CATEGORIES.values
  validates :game_type, inclusion: GAME_TYPES.values
  validates :channel, presence: true

  before_validation :ensure_channel

  # State Machine

  aasm column: :game_lifecycle do
    # Game has been configured and ready to begin
    state :configured, initial: true
    # Pulling from the API
    state :pending
    # There was a problem with the API
    state :error
    # When a question is being asked
    state :running
    # Shows the score and allows moving to the next question or to final tally
    state :answered
    # Game is over. Can either start a new one or abandon it
    state :finished

    event :finished_setup do
      transitions from: :pending, to: :running
    end

    event :error_detected do
      transitions from: :pending, to: :error
    end

    event :start do
      transitions from: :configured, to: :pending
    end

    event :answer do
      after do |*args|
        answer_with(*args)
      end

      transitions from: :running, to: :answered do
        guard do |answer|
          answer.in? [
            current_question.answer_1,
            current_question.answer_2,
            current_question.answer_3,
            current_question.answer_4
          ]
        end
      end
    end

    event :continue do
      transitions from: :answered, to: :running do
        guard do
          current_round < number_of_questions
        end

        after do
          increment(:current_round)
        end
      end
    end

    event :finish do
      transitions from: :answered, to: :finished do
        guard do
          current_round >= number_of_questions
        end
      end
    end
  end

  # Turbo/hotwire

  broadcasts_to :channel,
    inserts_by: :replace,
    target: ->(game) do
      ActionView::RecordIdentifier.dom_id(game)
    end

  # Database handling

  def current_question
    return nil if current_round > number_of_questions

    questions.offset(current_round - 1).limit(1).first
  end

  def current_answer
    current_question&.game_questions&.find_by(game: self)
  end

  def retrieve_trivia_questions
    RetrieveTriviaQuestionsJob.perform_later(self)
  end

  def score
    game_questions.where(correctly_answered: true).count(:id)
  end

  def answer_with(answer)
    if answer == current_question.correct_answer
      current_answer.update(correctly_answered: true)
    else
      current_answer.update(correctly_answered: false)
    end
  end

  # General Methods

  def api_attributes
    attrs = attributes.slice(
      "difficulty", "number_of_questions", "category", "game_type", "session_token"
    )

    {
      difficulty: attrs["difficulty"],
      amount: attrs["number_of_questions"],
      category: attrs["category"],
      type: attrs["game_type"],
      token: attrs["session_token"]
    }
  end

  # Presentational

  def percentage_correct
    (score.to_f / number_of_questions.to_f * 100).truncate
  end

  # Overrides

  def to_param
    channel
  end

  def to_key
    [:channel, channel]
  end

  private

  def ensure_channel
    if channel.nil?
      self.channel = SecureRandom.uuid
    end
  end
end
