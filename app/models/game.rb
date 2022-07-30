class Game < ApplicationRecord
  include AASM

  # Relationships

  has_many :game_questions
  has_many :questions, through: :game_questions
  has_many :players,
    # Players aren't related by ids because players are related to a
    # series of games, or game rounds, rather than concretely one single
    # game
    foreign_key: :channel,
    primary_key: :channel

  # Validation

  validates :difficulty, inclusion: DIFFICULTY_CHOICES.values
  validates :number_of_questions, numericality: {greater_than: 0, less_than_or_equal_to: 50}
  validates :category, inclusion: TRIVIA_CATEGORIES.values
  validates :game_type, inclusion: GAME_TYPES.values
  validates :channel, presence: true

  before_validation :ensure_channel

  scope :latest_round, ->(channel:) { where(channel: channel).order(created_at: :desc).limit(1) }
  scope :open_lobby, -> { where(game_lifecycle: "lobby_open") }

  # State Machine

  aasm column: :game_lifecycle do
    # Game has been configured and ready to begin
    state :configured, initial: true
    # Opens the lobby for other players to join
    state :lobby_open
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

    # Open the game in multiplayer
    event :open_lobby do
      transitions from: :configured, to: :lobby_open, guard: :multiplayer_enabled?

      after do |*args|
        open_lobby_for(*args)
      end
    end

    event :close_lobby do
      transitions from: :lobby_open, to: :pending, guard: :multiplayer_enabled?
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

  def multiplayer_enabled?
    return false unless Flipper.enabled?(:multiplayer_games)

    multiplayer
  end

  # Turbo/hotwire

  broadcasts_to :channel,
    inserts_by: :replace,
    target: ->(game) do
      ActionView::RecordIdentifier.dom_id(game)
    end

  # Database handling
  # TODO: Make a decision on whether or not to handle this in a service/decorator/delegator
  # See the delegator class in Ruby's standard library: https://blog.appsignal.com/2019/04/30/ruby-magic-hidden-gems-delegator-forwardable.html

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

  def open_lobby_for(username)
    players.create(username: username, host: true)
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

  def encode_hash_id
    Hashids.new(Rails.application.config.x.hashids_salt).encode(id)
  end

  def self.decode_hash_id(hashed_id)
    Hashids.new(Rails.application.config.x.hashids_salt).decode(hashed_id)[0]
  rescue Hashids::InputError
    nil
  end

  # Presentational
  # TODO: These should be moved to a presentation model

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
