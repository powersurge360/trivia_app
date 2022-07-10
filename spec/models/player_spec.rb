require "rails_helper"

RSpec.describe Player, type: :model do
  describe "validations" do
    context "when failing username validations" do
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

    context "when failing channel validations" do
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

    context "when failing join_code validations" do
      context "when creating players without a join_code" do
        subject do
          FactoryBot.build(:player).tap do |p|
            p.join_code = nil
            p.valid?
          end
        end

        it "should not be valid" do
          expect(subject.valid?).to be false
        end

        it "should have a join_code error" do
          expect(subject.errors).to include(:join_code)
        end
      end

      context "when creating players with a bad join_code" do
        subject do
          FactoryBot.build(:player).tap do |p|
            p.join_code = "#{p.join_code}-invalid-code"
            p.valid?
          end
        end

        it "should not be valid" do
          expect(subject.valid?).to be false
        end

        it "should have a join_code error" do
          expect(subject.errors).to include(:join_code)
        end
      end

      context "when updating players" do
        subject do
          FactoryBot.create(:player).tap do |p|
            p.username = "second-name"
            p.join_code = "some random invalid code"
            p.save
          end
        end
        it "should be valid" do
          expect(subject.valid?).to be true
        end

        it "should have no errors" do
          expect(subject.errors).to be_empty
        end
      end
    end
  end
end
