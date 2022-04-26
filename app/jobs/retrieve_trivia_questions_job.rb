class RetrieveTriviaQuestionsJob < ApplicationJob
  attr_accessor :opentdb, :game

  queue_as :default

  def logger
    tagged_logger = super

    if game&.id
      tagged_logger.tagged("Game ID: #{game.id}")
    else
      tagged_logger
    end
  end

  def perform(game)
    self.game = game
    self.opentdb = External::OpenTdbService.new

    if game.session_token.nil?
      game.session_token = opentdb.tokens.request.data
    end

    question_response = opentdb.questions.get(**game.api_attributes)

    logger.debug("Game attributes: #{game.api_attributes}")
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
      question_objs = Question.upsert_all(questions.map(&:attributes), returning: ["id"])

      game.question_ids = question_objs.map { |res| res["id"] }
      game.finished_setup
    end

    game.save
  end

  def handle_error(question_response)
    game.error_detected

    case question_response.error
    when :no_token
      logger.error("Bad token generated for game")

      game.error_message = "There was an error generating the game"
    when :token_exhausted
      logger.info("Token was exhausted")

      game.error_message = "Not enough questions to fill a round"
    when :invalid_parameter
      logger.error("An invalid parameter was passed")

      game.error_message = "An error occurred retrieving questions"
    when :no_results
      logger.info("Not enough questions for the current configuration")

      game.error_message = "Not enough questions for the current settings"
    else
      logger.error("No known cause for this error")

      game.error_message = "An error occurred retrieving questions"
    end

    game.save
  end
end
