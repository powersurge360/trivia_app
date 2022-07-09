require "rails_helper"

RSpec.describe Player, type: :model do
  describe "validations" do
    describe "failing username validations" do
      subject do
        invalid_player.tap { |p| p.valid? }
      end

      let(:pre_existing_player) do
        FactoryBot.create(:player, username: "foobar", channel: SecureRandom.uuid)
      end

      let(:invalid_player) do
        FactoryBot.build(:player, username: "foobar", channel: pre_existing_player.channel)
      end

      it "should not be valid" do
        expect(subject.valid?).to be false
      end

      it "should have a username error" do
        expect(subject.errors).to include(:username)
      end
    end

    describe "failing channel validations" do
      subject do
        FactoryBot.build(:player, channel: nil, game: nil).tap do |p|
          p.valid?
        end
      end

      it "should not be valid" do
        expect(subject.valid?).to be false
      end

      it "should have a channel error" do
        expect(subject.errors).to include(:channel)
      end
    end
  end
end
