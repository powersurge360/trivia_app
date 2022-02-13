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
    it "should return nil if the current_round is further than possible" do
      game = create :game,
        :valid,
        number_of_questions: 10,
        current_round: 11

      expect(game.current_question).to be_nil
    end

    it "should return nil if the current_round is the last possible" do
      game = create :game,
        :valid,
        number_of_questions: 10,
        current_round: 10

      expect(game.current_question).to be_nil
    end

    it "should only grab a single question" do
      question = create :question, :valid
      game = create :game,
        :valid,
        questions: [question],
        number_of_questions: 10,
        current_round: 1

      expect(game.current_question).to_not be_nil
      expect(game.current_question.id).to eql(question.id)
    end

    it "should be paginated according to current_round" do
      questions = [
        create(:question, :valid),
        create(:question, :valid, body: "This is an example body!!")
      ]

      game = create :game,
        :valid,
        questions: questions,
        number_of_questions: 2,
        current_round: 1

      expect(game.current_question).to eql(questions[0])
      game.current_round = 2
      expect(game.current_question).to eql(questions[1])
    end

    it "should return nil when no valid question is found" do
      questions = [
        create(:question, :valid),
        create(:question, :valid, body: "This is an example body!!")
      ]

      game = create :game,
        :valid,
        questions: questions,
        number_of_questions: 5,
        current_round: 3

      expect(game.current_question).to be_nil
    end
  end

  describe "#current_answer" do
    it "should retrieve the GameQuestion for the currently active question" do
      questions = [
        create(:question, :valid),
        create(:question, :valid, body: "This is an example body!!")
      ]

      game = create :game,
        :valid,
        questions: questions,
        number_of_questions: 10,
        current_round: 1

      game_question = GameQuestion.find_by(question: questions[0], game: game)

      expect(game.current_answer).to eql(game_question)
      game.current_round = 2
      expect(game.current_answer).to_not eql(game_question)
    end

    it "should return nil when there is no valid currently active question" do
      question = create :question, :valid

      game = create :game,
        :valid,
        questions: [question],
        number_of_questions: 10,
        current_round: 2

      expect(game.current_answer).to be_nil
    end
  end

  describe "#score" do
    it "should count all of the correct answers"
  end

  describe "#answer_with" do
    it "should mark the current answer correct when correct"
    it "should mark the current answer incorrect when incorrect"
  end

  describe "state machine" do
    context "answer transition" do
      # After is handled by #answer_with

      context "guard" do
        it "should allow a known answer for this question"

        it "should not allow an unknown answer for this question"
      end
    end

    context "continue transition" do
      context "guard" do
        it "should allow transitions when there are legal rounds left"

        it "should not allow transitions when there are no legal rounds left"
      end

      context "after" do
        it "should increase the current round"
      end
    end

    context "finish transition" do
      context "guard" do
        it "should allow finishing a game when out of legal rounds to progress through"

        it "should not allow finishing a game when legal rounds remain"
      end
    end
  end
end
