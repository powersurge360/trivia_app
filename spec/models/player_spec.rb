require "rails_helper"

RSpec.describe Player, type: :model do
  describe "#valid?" do
    context "when failing username validations" do
      let(:game) do
        create(:game, channel: SecureRandom.uuid, game_lifecycle: "lobby_open")
      end

      let!(:pre_existing_player) do
        create(
          :player,
          username: "foobar",
          join_code: game.encode_hash_id
        )
      end

      let(:invalid_player) do
        build(
          :player,
          username: "foobar",
          join_code: game.encode_hash_id
        )
      end

      subject do
        invalid_player.tap { |p| p.valid? }
      end

      it { expect(subject.valid?).to be false }

      it { expect(subject.errors).to include(:username) }
    end

    context "when failing channel validations" do
      subject do
        build(:player, channel: nil, game: nil).tap do |p|
          p.valid?
        end
      end

      it { expect(subject.valid?).to be false }

      it { expect(subject.errors).to include(:channel) }
    end

    context "when player is not a host" do
      context "when failing join_code validations" do
        context "when creating players without a join_code" do
          subject do
            build(:player).tap do |p|
              p.valid?
            end
          end

          it { expect(subject.valid?).to be false }

          it { expect(subject.errors).to include(:join_code) }
        end

        context "when creating players with a bad join_code" do
          subject do
            build(:player).tap do |p|
              p.join_code = "#{p.join_code}-invalid-code"
              p.valid?
            end
          end

          it { expect(subject.valid?).to be false }

          it { expect(subject.errors).to include(:join_code) }
        end

        context "when updating players" do
          subject do
            create(:player, :with_game).tap do |p|
              p.username = "second-name"
              p.join_code = "some random invalid code"
              p.save
            end
          end

          it { expect(subject.valid?).to be true }

          it { expect(subject.errors).to be_empty }
        end
      end
    end

    context "when player is a host" do
      subject do
        build(:player, :with_game, host: true, join_code: nil).tap do |p|
          p.join_code = nil
          p.valid?
        end
      end

      context "when there is no join code" do
        it { expect(subject.valid?).to be true }
      end
    end
  end

  describe "#ensure_channel" do
    context "on create" do
      let(:player) { build(:player) }

      it "should run" do
        expect(player).to receive(:ensure_channel)
        player.save
      end
    end

    context "on update" do
      let(:player) { create(:player, :with_game) }

      it "should not run" do
        expect(player).to_not receive(:ensure_channel)

        player.update(username: "Some change")
      end
    end

    context "when there is a join code" do
      context "and it is valid" do
        let(:player) { build(:player, :with_game, channel: nil) }

        it "should populate a channel" do
          expect(player.channel).to be nil

          player.send(:ensure_channel)

          expect(player.channel).to eql(player.game.channel)
        end
      end

      context "and it is invalid" do
        let(:player) { build(:player) }

        it "should not populate a join code" do
          expect(player.channel).to be nil

          player.send(:ensure_channel)

          expect(player.channel).to be nil
        end
      end

      context "and it refers to a game that is not in the correct state" do
        let(:game) { create(:game) }

        let(:player) { build(:player, join_code: game.encode_hash_id) }

        it "should set the channel to nil" do
          expect(player.channel).to be nil

          player.send(:ensure_channel)

          expect(player.channel).to be nil
        end
      end
    end
  end

  describe "#join_code_matches_game" do
    context "player is a host" do
      let(:player) { build(:player, host: true) }

      it "should not be called" do
        expect(player).to_not receive(:join_code_matches_game)

        player.valid?
      end
    end

    context "player is not a host" do
      let(:player) { build(:player, host: false) }
      let(:game) { create(:game, :lobby_open) }

      context "join_code matches game" do
        before(:each) do
          player.join_code = game.encode_hash_id
          player.channel = game.channel
        end

        it "should set no errors on join_code" do
          expect { player.send(:join_code_matches_game) }.to_not change { player.errors[:join_code].count }
        end
      end

      context "join_code does not match game" do
        before(:each) do
          player.join_code = game.encode_hash_id
          player.channel = "nonsense"
        end

        it "should set errors on join_code" do
          expect { player.send(:join_code_matches_game) }.to change { player.errors[:join_code].count }
        end
      end
    end
  end
end
