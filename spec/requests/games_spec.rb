require "rails_helper"

RSpec.describe "Games", type: :request do
  describe "GET /" do
    it "shows a form" do
      get root_path

      expect(response).to be_successful
      expect(response.body).to include("form")
    end
  end

  describe "POST /" do
    it "redirects to the game page" do
      expect(Game.count).to eql(0)

      post games_path, params: {
        game: {
          number_of_questions: 10
        }
      }

      expect(response).to redirect_to game_path(Game.last)
      expect(Game.count).to eql(1)
      follow_redirect!

      expect(response.body).to match(/Looking up some great questions/)
    end

    describe "given bad input" do
      it "should show errors" do
        post games_path, params: {
          game: {
            number_of_questions: 0
          }
        }

        expect(response).to be_unprocessable

        expect(response.body).to match(/Number of questions must be greater than 0/)
      end
    end
  end

  describe "GET /games/:channel" do
    context "when an error has been detected" do
      it "should display the error message" do
        game = create :game,
          error_message: "API Token has been exhausted",
          game_lifecycle: "error"

        get game_path(game)

        expect(response.body).to match(/API Token has been exhausted/)
      end
    end
  end

  describe "POST /games/:channel/start" do
    let(:question) { create :question, :valid }

    it "should allow a transition to the running state" do
      game = create :game, :valid, questions: [question], game_lifecycle: "ready"

      post start_game_path(game)

      expect(response).to be_redirect
      game.reload
      follow_redirect!

      expect(game.game_lifecycle).to eql("running")
      expect(response.body).to match(/#{question.body}/)
    end

    it "should fail when attempting to transition an invalid state" do
      game = create :game, :valid, questions: [question], game_lifecycle: "pending"

      post start_game_path(game)

      expect(response).to be_unprocessable
      game.reload
      expect(game.game_lifecycle).to eql("pending")
    end
  end

  describe "POST /games/:channel/answer" do
    let(:question) { create :question, :valid }

    it "should allow a transition to the answered state" do
      game = create :game, :valid, questions: [question], game_lifecycle: "running"

      post answer_game_path(game, answer: question.answer_1)

      expect(response).to be_redirect
      game.reload
      expect(game.game_lifecycle).to eql("answered")
    end

    it "should fail when attempting to transition an invalid state" do
      game = create :game, :valid, questions: [question], game_lifecycle: "pending"

      post answer_game_path(game, answer: question.answer_1)

      expect(response).to be_unprocessable
      game.reload
      expect(game.game_lifecycle).to eql("pending")
    end

    it "should not allow invalid answers" do
      game = create :game, :valid, questions: [question], game_lifecycle: "running"

      post answer_game_path(game, answer: "Prince Albert in a Can")

      expect(response).to be_unprocessable
      game.reload
      expect(game.game_lifecycle).to eql("running")
    end

    it "should mark answer correct when correct" do
      game = create :game, :valid, questions: [question], game_lifecycle: "running"

      post answer_game_path(game, answer: question.correct_answer)

      game.reload
      follow_redirect!

      expect(game.current_answer.correctly_answered).to be true
      expect(response.body).to match(/Correct!/)
    end

    it "should mark answer incorrect when incorrect" do
      game = create :game, :valid, questions: [question], game_lifecycle: "running"

      post answer_game_path(game, answer: question.answer_2)

      game.reload
      follow_redirect!

      expect(game.current_answer.correctly_answered).to be false
      expect(response.body).to match(/Incorrect!/)
    end
  end

  describe "POST /games/:channel/finish" do
    let(:question) { create :question, :valid }

    it "should allow a transition to the finished state" do
      game = create :game,
        :valid,
        questions: [question],
        game_lifecycle: "answered",
        current_round: 10,
        number_of_questions: 10

      post finish_game_path(game)

      expect(response).to be_redirect
      game.reload
      follow_redirect!

      expect(game.game_lifecycle).to eql("finished")
      expect(response.body).to match(/You got [0-9]{1,2}% right!/)
    end

    it "should fail when attempting to transition an invalid state" do
      game = create :game,
        :valid,
        questions: [question],
        game_lifecycle: "running",
        current_round: 10,
        number_of_questions: 10

      post finish_game_path(game)

      expect(response).to have_http_status(:unprocessable_entity)
      game.reload
      expect(game.game_lifecycle).to eql("running")
    end

    it "should fail when attempting to finish before reaching the end of the game" do
      game = create :game,
        :valid,
        questions: [question],
        game_lifecycle: "answered",
        current_round: 8,
        number_of_questions: 10

      post finish_game_path(game)

      expect(response).to have_http_status(:unprocessable_entity)
      game.reload
      expect(game.game_lifecycle).to eql("answered")
    end
  end

  describe "POST /games/:channel/continue" do
    let(:questions) do
      [
        create(:question, :valid),
        create(:question, :valid, body: "This is just a nonsense body!")
      ]
    end

    it "should allow a transition to the running state" do
      game = create :game,
        :valid,
        questions: questions,
        game_lifecycle: "answered",
        current_round: 1,
        number_of_questions: 2

      post continue_game_path(game)

      expect(response).to be_redirect

      game.reload
      follow_redirect!

      expect(game.game_lifecycle).to eql("running")
      expect(response.body).to match(/#{game.current_question.body}/)
    end

    it "should fail when attempting to transition an invalid state" do
      game = create :game,
        :valid,
        questions: questions,
        game_lifecycle: "pending"

      post continue_game_path(game)

      expect(response).to be_unprocessable

      game.reload

      expect(game.game_lifecycle).to eql("pending")
    end

    it "should fail when trying to continue and the game is over." do
      game = create :game,
        :valid,
        questions: questions,
        game_lifecycle: "answered"

      post continue_game_path(game)

      expect(response).to be_unprocessable

      game.reload

      expect(game.game_lifecycle).to eql("answered")
    end
  end

  describe "POST /games/:channel/new_round" do
    let(:question) { create :question, :valid }

    it "should create a new game object with the same configured data" do
      game = create :game,
        :valid,
        questions: [question],
        game_lifecycle: "finished"

      expect(Game.where(channel: game.channel).count).to eql(1)

      post new_round_game_path(game)

      expect(response).to be_redirect
      expect(Game.where(channel: game.channel).count).to eql(2)

      new_game = Game.where(channel: game.channel).last

      expect(new_game.api_attributes.to_json).to eql(game.api_attributes.to_json)
    end

    it "should reset the rounds on the new round" do
      game = create :game,
        :valid,
        questions: [question],
        game_lifecycle: "finished",
        current_round: 10,
        number_of_questions: 10

      post new_round_game_path(game)

      expect(response).to be_redirect

      new_game = Game.where(channel: game.channel).last

      expect(new_game.current_round).to eql(1)
    end

    it "should set the pending status on the new round" do
      game = create :game,
        :valid,
        questions: [question],
        game_lifecycle: "finished",
        current_round: 10,
        number_of_questions: 10

      post new_round_game_path(game)

      expect(response).to be_redirect

      new_game = Game.where(channel: game.channel).last

      expect(new_game.game_lifecycle).to eql("pending")
    end
  end
end
