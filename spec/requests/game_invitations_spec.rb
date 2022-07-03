require "rails_helper"

RSpec.describe "GameInvitations", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get game_invitation_path(channel: SecureRandom.uuid)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get game_invitation_path(channel: SecureRandom.uuid)
      expect(response).to have_http_status(:success)
    end
  end
end
