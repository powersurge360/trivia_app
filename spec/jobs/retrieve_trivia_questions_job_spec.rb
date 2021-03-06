require "rails_helper"

RSpec.describe RetrieveTriviaQuestionsJob, type: :job do
  let(:game) {
    Game.create(game_lifecycle: "pending")
  }

  it "should use the game's configuration to collect the questions", :vcr do
    expect(Question.count).to eql(0)

    RetrieveTriviaQuestionsJob.perform_now(game)

    expect(Question.count).to eql(10)
  end

  it "should assign a session token", :vcr do
    expect(game.session_token).to be_nil
    RetrieveTriviaQuestionsJob.perform_now(game)

    game.reload
    expect(game.session_token).to_not be_nil
  end

  it "should assign 10 questions to the game", :vcr do
    expect(game.questions.count).to eql(0)

    RetrieveTriviaQuestionsJob.perform_now(game)

    expect(game.questions.count).to eql(10)
  end

  it "should set the state to running", :vcr do
    expect(game.game_lifecycle).to eql("pending")

    RetrieveTriviaQuestionsJob.perform_now(game)

    game.reload
    expect(game.game_lifecycle).to eql("running")
  end

  describe "#handle_error" do
    let(:question_response) { instance_double(External::OpenTdb::QuestionsResponse) }

    it "populate an error message", :vcr do
      allow(question_response).to receive(:error).and_return(:no_token)

      job = RetrieveTriviaQuestionsJob.new
      job.game = game
      job.opentdb = External::OpenTdbService.new

      expect(game.error_message).to be_nil
      job.handle_error(question_response)
      expect(game.error_message).to_not be_nil
    end

    it "should set the lifecycle to error" do
      allow(question_response).to receive(:error).and_return(:no_token)

      job = RetrieveTriviaQuestionsJob.new
      job.game = game
      job.opentdb = External::OpenTdbService.new

      expect(game.game_lifecycle).to eql("pending")
      job.handle_error(question_response)
      game.reload
      expect(game.game_lifecycle).to eql("error")
    end
  end
end
