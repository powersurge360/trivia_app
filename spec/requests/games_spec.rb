require 'rails_helper'

RSpec.describe "Games", type: :request do
  describe "GET /" do
    it 'shows a form' do
      get root_path

      expect(response).to be_successful
      expect(response.body).to include("form")
    end
  end

  describe "POST /" do
    it 'redirects to the game page' do
      expect(Game.count).to eql(0)

      post games_path, params: {
        game: {
          number_of_questions: 10
        }
      }

      expect(response).to redirect_to game_path(Game.last)
      expect(Game.count).to eql(1)
    end
  end
end
