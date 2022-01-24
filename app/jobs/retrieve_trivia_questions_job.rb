class RetrieveTriviaQuestionsJob < ApplicationJob
  attr_accessor :opentdb, :game

  queue_as :default

  def logger
    tagged_logger = super

    if self.game&.id
      tagged_logger.tagged("Game ID: #{self.game.id}")
    else
      tagged_logger
    end
  end

  def perform(game)
    self.game = game
    self.opentdb = External::OpenTdbService.new

    game.session_token = self.opentdb.tokens.request.data

    question_response = self.opentdb.questions.get(**game.api_attributes)

    logger.debug("Question response: #{question_response.data}")

    if !question_response.successful?
      handle_error(question_response)

      return
    end

    questions = question_response.data.map do |question|
      question = Question.from_api(question)

      # When inserting or upserting or updating, these fields don't get set.
      question.updated_at = Time.now
      question.created_at = Time.now

      question
    end

    if questions.map(&:valid?).all?
      question_objs = Question.upsert_all(questions.map(&:attributes), returning: [ "id" ])

      game.question_ids = question_objs.map { |res| res['id'] }
      game.game_lifecycle = "ready"
    end

    game.save
  end

  def handle_error(question_response)
    self.game.game_lifecycle = 'error'

    case question_response.response_code
    when :no_token
      logger.error('Bad token generated for game')

      self.game.error_message = 'There was an error generating the game'
    when :token_exhausted
      logger.info('Token was exhausted')

      self.game.error_message = 'All possible questions for these settings have been exhausted'
    when :invalid_parameter
      logger.error('An invalid parameter was passed')

      self.game.error_message = 'An error occurred retrieving questions'
    when :no_results
      logger.info('Not enough questions for the current configuration')

      self.game.error_message = 'Not enough questions for the current settings'
    else
      logger.error('No known cause for this error')

      self.game.error_message = 'An error occurred retrieving questions'
    end
  end
end
