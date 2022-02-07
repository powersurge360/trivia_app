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

  describe "POST /games/:channel/start" do
    let(:question) { create :question, :valid }

    it "should allow a transition to the running state" do
      game = create :game, :valid, questions: [question], game_lifecycle: "ready"

      post start_game_path(game)

      expect(response).to have_http_status(:no_content)
      game.reload
      expect(game.game_lifecycle).to eql("running")
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

      expect(response).to have_http_status(:no_content)
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

      expect(response).to have_http_status(:no_content)
      game.reload
      expect(game.game_lifecycle).to eql("finished")
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
    it "should allow a transition to the running state"
    it "should fail when attempting to transition an invalid state"
  end

  describe "POST /games/:channel/finish" do
    it "should allow a transition to the finished state"
    it "should fail when attempting to transition to an invalid state"
  end

  describe "POST /games/:channel/new_round" do
    it "should create a new game object with the same configured data"
    it "should reset the rounds on the new round"
    it "should set the pending status on the new round"
  end
end
