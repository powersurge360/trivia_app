require "rails_helper"

RSpec.describe "Invitations", type: :request do
  context "with the multiplayer feature turned off" do
    before(:each) { Flipper.disable(:multiplayer_games) }
    let(:game) { create(:game) }

    it "should have the multiplayer games flag enabled" do
      expect(Flipper.enabled?(:multiplayer_games)).to be false
    end

    describe "GET /invitations/" do
      it "should render 404" do
        get invitations_path(game_channel: game)

        expect(response).to be_not_found
      end
    end

    describe "POST /invitations/" do
      it "should render 404" do
        post invitations_path(game)

        expect(response).to be_not_found
      end
    end
  end

  context "with the multiplayer feature turned on" do
    before(:each) { Flipper.enable(:multiplayer_games, true) }

    describe "GET /invitations" do
      it "should show a username input"

      it "should show a join input"

      context "user name in session" do
        it "should pre-populate username input"
      end
    end

    describe "POST /invitations" do
      describe "when the game is not in the lobby_open state" do
        let(:game) { create(:game) }
      end

      describe "when the game is in the lobby_open state" do
        let(:game) { create(:game, game_lifecycle: "lobby_open") }

        context "when another user has the same username" do
          let(:pre_existing_player) { create(:player, username: "dark_knight") }

          it "should render a validation error" do
            post invitations_path,
              params: {
                player: {
                  username: "dark_knight"
                }
              }

            expect(response).to be_unprocessable
          end
        end

        context "when the join code is invalid" do
          it "should render a validation error" do
            post invitations_path,
              params: {
                player: {
                  username: "dark_knight",
                  join_code: "#{game.encode_hash_id}-invalid"
                }
              }

            expect(response).to be_unprocessable
          end
        end

        context "when both inputs are correct" do
          before(:each) do
            post invitations_path,
              params: {
                player: {
                  username: "dark_knight",
                  join_code: game.encode_hash_id
                }
              }
          end

          it "should redirect to the game channel" do
            expect(response).to redirect_to(game)
          end
        end
      end
    end
  end
end
