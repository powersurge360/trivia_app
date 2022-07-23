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

    it "should default to configured state" do
      subject.save

      expect(subject.game_lifecycle).to eql("configured")
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
    it "should count all of the correct answers" do
      questions = [
        create(:question, :valid),
        create(:question, :valid, body: "This is an example body!!"),
        create(:question, :valid, body: "This is the 2nd example body!!"),
        create(:question, :valid, body: "This is the 3rd example body!!"),
        create(:question, :valid, body: "This is the 4th example body!!"),
        create(:question, :valid, body: "This is the 5th example body!!"),
        create(:question, :valid, body: "This is the 6th example body!!"),
        create(:question, :valid, body: "This is the 7th example body!!"),
        create(:question, :valid, body: "This is the 8th example body!!"),
        create(:question, :valid, body: "This is the 9th example body!!"),
        create(:question, :valid, body: "This is the 10th example body!!")
      ]

      game = create :game,
        :valid,
        questions: questions,
        number_of_questions: 10,
        current_round: 1

      GameQuestion.where(
        game: game,
        # Only set the first 4 questions to correct
        question: questions[0...4]
      ).update(correctly_answered: true)

      expect(game.score).to eql(4)
    end
  end

  describe "#answer_with" do
    it "should mark the current answer correct when correct" do
      question = create :question, :valid, answer_1: "Frankfurt", correct_answer: "Frankfurt"
      game = create :game, :valid, questions: [question]

      game_question = GameQuestion.find_by(game: game, question: question)
      expect(game_question.correctly_answered).to be_nil

      game.answer_with("Frankfurt")

      game_question.reload
      expect(game_question.correctly_answered).to be true
    end

    it "should mark the current answer incorrect when incorrect" do
      question = create :question, :valid, answer_1: "Frankfurt", correct_answer: "Frankfurt"
      game = create :game, :valid, questions: [question]

      game_question = GameQuestion.find_by(game: game, question: question)
      expect(game_question.correctly_answered).to be_nil

      game.answer_with("Lexington")

      game_question.reload
      expect(game_question.correctly_answered).to be false
    end
  end

  describe "state machine" do
    context "answer transition" do
      # After is handled by #answer_with

      context "guard" do
        it "should allow a known answer for this question" do
          question = create :question, :valid
          game = create :game, :valid, questions: [question], game_lifecycle: "running"

          expect { game.answer(question.answer_1) }.to_not raise_error
        end

        it "should not allow an unknown answer for this question" do
          question = create :question, :valid
          game = create :game, :valid, questions: [question], game_lifecycle: "running"

          expect {
            game.answer("beavers can be fooled by running a pipe through a dam, called a beaver deceiver")
          }.to raise_error(AASM::InvalidTransition)
        end
      end
    end

    context "continue transition" do
      context "guard" do
        it "should allow transitions when there are legal rounds left" do
          game = create :game,
            :valid,
            game_lifecycle: "answered",
            current_round: 1,
            number_of_questions: 10

          expect { game.continue }.to_not raise_error
        end

        it "should not allow transitions when there are no legal rounds left" do
          game = create :game,
            :valid,
            game_lifecycle: "answered",
            current_round: 10,
            number_of_questions: 10

          expect { game.continue }.to raise_error(AASM::InvalidTransition)
        end
      end

      context "after" do
        it "should increase the current round" do
          game = create :game,
            :valid,
            game_lifecycle: "answered",
            current_round: 1,
            number_of_questions: 10

          expect { game.continue }.to change { game.current_round }.from(1).to(2)
        end
      end
    end

    context "finish transition" do
      context "guard" do
        it "should allow finishing a game when out of legal rounds to progress through" do
          game = create :game,
            :valid,
            game_lifecycle: "answered",
            current_round: 10,
            number_of_questions: 10

          expect { game.finish }.to_not raise_error
        end

        it "should not allow finishing a game when legal rounds remain" do
          game = create :game,
            :valid,
            game_lifecycle: "answered",
            current_round: 5,
            number_of_questions: 10

          expect { game.finish }.to raise_error(AASM::InvalidTransition)
        end
      end
    end
  end

  context "with multiplayer feature turned off" do
    before(:each) { Flipper.disable(:multiplayer_games) }

    it "should have the multiplayer feature turned off" do
      expect(Flipper.enabled?(:multiplayer_games)).to be false
    end

    describe "open_lobby transition" do
      subject { create :game, game_lifecycle: :configured }

      it "should not be allowed" do
        expect { subject.open_lobby }.to raise_error(AASM::InvalidTransition)
      end
    end

    describe "close_lobby transition" do
      subject { create :game, game_lifecycle: :lobby_open }

      it "should not be allowed" do
        expect { subject.open_lobby }.to raise_error(AASM::InvalidTransition)
      end
    end
  end

  context "with multiplayer feature turned on" do
    before(:each) { Flipper.enable(:multiplayer_games) }

    it "should have the muliplayer games flag enabled" do
      expect(Flipper.enabled?(:multiplayer_games)).to be true
    end

    describe "#encode_hash_id" do
      let(:game) do
        create :game,
          :valid
      end

      subject! { game.encode_hash_id }

      it "should return the hash consistently" do
        expect(subject).to eql(game.encode_hash_id)
      end

      it "should change when the id changes" do
        game.increment!(:id)

        expect(subject).to_not eql(game.encode_hash_id)
      end
    end

    describe "#decode_hash_id" do
      let(:game) do
        create :game,
          :valid,
          id: 90
      end

      it "should decode the correct id" do
        id = Game.decode_hash_id(game.encode_hash_id)

        expect(id).to eql(game.id)
      end
    end

    describe "open_lobby transition" do
      it "should assign a game host"

      it "should progress to the lobby_open state"

      it "should set a host"
    end
  end
end
