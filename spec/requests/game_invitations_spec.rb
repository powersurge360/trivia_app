require "rails_helper"

RSpec.describe "GameInvitations", type: :request do
  context "with the multiplayer feature turned off" do
    let(:game) { FactoryBot.create(:game) }

    it "should have the multiplayer games flag enabled" do
      expect(Flipper.enabled?(:multiplayer_games)).to be false
    end

    describe "GET /game_invitations/:channel" do
      it "should render 404" do
        get game_invitation_path(game)

        expect(response).to be_not_found
      end
    end

    describe "PUT /game_invitations/:channel" do
      it "should render 404" do
        put game_invitation_path(game)

        expect(response).to be_not_found
      end
    end
  end

  context "with the multiplayer feature turned on" do
    describe "GET /game_invitations/:channel" do
      it "should show a username input"

      it "should show a join input"
    end

    describe "PUT /game_invitations/:channel" do
      context "when another user has the same username" do
        it "should render a validation error"
      end

      context "when the join code is invalid" do
        it "should render a validation error"
      end

      context "when both inputs are correct" do
        it "should redirect to the game channel"

        it "should display a list of players"

        it "should not display a button to begin the next phase of the game"
      end
    end
  end
end
