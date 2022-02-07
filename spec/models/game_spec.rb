require "rails_helper"

RSpec.describe Game, type: :model do
  let(:valid_game) do
    build :game, :valid
  end

  let(:invalid_game) do
    build :game, :invalid
  end

  describe "with valid attributes passed" do
    subject { valid_game }

    it "should save" do
      expect(subject.save).to be true
    end

    it "should default to pending state" do
      subject.save

      expect(subject.game_lifecycle).to eql("pending")
    end

    it "should have questions up to 50" do
      valid_game.number_of_questions = 50

      expect(valid_game.save).to be true
    end
  end

  describe "with invalid attributes passed" do
    subject { invalid_game }

    it "should not save" do
      expect(subject.save).to be false
    end

    it "should not allow questions above 50" do
      valid_game.number_of_questions = 51

      expect(valid_game.save).to be false
    end

    it "should have errors for game_type" do
      subject.valid?

      expect(subject.errors).to include(:game_type)
    end

    it "should have errors for difficulty" do
      subject.valid?

      expect(subject.errors).to include(:difficulty)
    end

    it "should have errors for number_of_questions" do
      subject.valid?

      expect(subject.errors).to include(:number_of_questions)
    end

    it "should have errors for category" do
      subject.valid?

      expect(subject.errors).to include(:category)
    end
  end

  describe "#current_question" do
    it "should return nil if the current_round is further than possible"

    it "should only grab a single question"

    it "should be paginated according to current_round"
  end

  describe "#current_answer" do
    it "should retrieve the GameQuestion for the currently active question"
  end

  describe "#score" do
    it "should count all of the correct answers"
  end

  describe "#answer_with" do
    it "should mark the current answer correct when correct"
    it "should mark the current answer incorrect when incorrect"
  end
end
