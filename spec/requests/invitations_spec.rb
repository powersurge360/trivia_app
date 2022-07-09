require "rails_helper"

RSpec.describe "Invitations", type: :request do
  context "with the multiplayer feature turned off" do
    before(:each) { Flipper.disable(:multiplayer_games) }
    let(:game) { FactoryBot.create(:game) }

    it "should have the multiplayer games flag enabled" do
      expect(Flipper.enabled?(:multiplayer_games)).to be false
    end

    describe "GET /game_invitations/:channel" do
      it "should render 404" do
        get game_invitations_path(game_channel: game)

        expect(response).to be_not_found
      end
    end

    describe "POST /game_invitations/:channel" do
      it "should render 404" do
        post game_invitations_path(game)

        expect(response).to be_not_found
      end
    end
  end

  context "with the multiplayer feature turned on" do
    before(:each) { Flipper.enable(:multiplayer_games, true) }
    describe "when the game is not in the lobby_open state" do
      let(:game) { FactoryBot.create(:game) }

      it "should 404" do
        expect do
          get game_invitations_path(game)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe "GET /game/:channel/invitations" do
      it "should show a username input"

      it "should show a join input"
    end

    describe "POST /game/:channel/invitations" do
      describe "when the game is not in the lobby_open state" do
        let(:game) { FactoryBot.create(:game) }

        it "should 404" do
          expect do
            post game_invitations_path(game_channel: game)
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      describe "when the game is in the lobby_open state" do
        let(:game) { FactoryBot.create(:game, game_lifecycle: "lobby_open") }

        context "when another user has the same username" do
          let(:pre_existing_player) { FactoryBot(:player, username: "dark_knight") }

          it "should render a validation error" do
            post game_invitations_path(game_channel: game),
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
            post game_invitations_path(game_channel: game),
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
            post game_invitations_path(game_channel: game.channel),
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

          it "should display a list of players"

          it "should not display a button to begin the next phase of the game"
        end
      end
    end
  end
end
