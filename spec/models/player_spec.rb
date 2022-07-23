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
              p.join_code = nil
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
  end

  describe "#join_code_matches_game" do
  end
end
