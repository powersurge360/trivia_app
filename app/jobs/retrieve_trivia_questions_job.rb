class RetrieveTriviaQuestionsJob < ApplicationJob
  queue_as :default

  def perform(game)
    opentdb = External::OpenTdbService.new

    question_response = opentdb.questions.get(**game.api_attributes)

    if !question_response.successful?
      # TODO: Detect failures and if it can be recovered from
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
      Question.upsert_all(questions.map(&:attributes))
    end
  end
end
