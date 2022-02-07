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

  describe "POST /games/:id/start" do
    let(:question) { create :question, :valid }
    subject { create :game, :valid, questions: [question], game_lifecycle: "ready" }

    it "should allow a transition to the running state" do
      post start_game_path(subject)

      expect(response).to have_http_status(:no_content)
      subject.reload
      expect(subject.game_lifecycle).to eql("running")
    end

    it "should fail when attempting to transition an invalid state" do
      subject.game_lifecycle = "pending"
      subject.save

      post start_game_path(subject)

      expect(response).to be_unprocessable
      subject.reload
      expect(subject.game_lifecycle).to eql("pending")
    end
  end
end
