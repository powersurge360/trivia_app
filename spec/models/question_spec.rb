require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:valid_question) {
    build :question, :valid
  }

  let(:invalid_question) {
    build :question, :invalid
  }

  let(:valid_multiple_json) {
    JSON.parse('{
      "category": "Entertainment: Video Games",
      "type": "multiple",
      "difficulty": "medium",
      "question": "In Terraria, what does the Wall of Flesh not drop upon defeat?",
      "correct_answer": "Picksaw",
      "incorrect_answers": [
        "Pwnhammer",
        "Breaker Blade",
        "Laser Rifle"
      ]
    }')
  }

  let(:valid_boolean_json) {
    JSON.parse('{
      "category": "History",
      "type": "boolean",
      "difficulty": "medium",
      "question": "Sargon II, a king of the Neo-Assyrian Empire, was a direct descendant of Sargon of Akkad.",
      "correct_answer": "False",
      "incorrect_answers": ["True"]
    }')
  }

  it 'should hash the body to create the pk automatically' do
    expect(valid_question.id).to be_nil
    expect(valid_question.valid?).to be true
    expect(valid_question.id).to eql(Question.hash_body(valid_question.body))
  end

  describe 'invalid attributes' do
    subject { invalid_question }

    it 'should not save invalid models' do
      expect(subject.id).to be_nil
      expect(subject.valid?).to be false
    end

    it 'should have an answer_1 error' do
      subject.valid?
      expect(subject.errors).to include(:answer_1)
    end

    it 'should have an answer_2 error' do
      subject.valid?
      expect(subject.errors).to include(:answer_2)
    end

    it 'should have a correct_answer error' do
      subject.valid?
      expect(subject.errors).to include(:correct_answer)
    end

    it 'should have a difficulty error' do
      subject.valid?
      expect(subject.errors).to include(:difficulty)
    end
  end

  describe '#from_api' do
    describe 'being passed a multiple choice question' do
      it 'should return a valid question object' do
        question = Question.from_api(valid_multiple_json)

        expect(question.valid?).to be true
      end

      it 'should not have empty answers 3 and 4' do
        question = Question.from_api(valid_multiple_json)

        expect(question.answer_3).to_not be_nil
        expect(question.answer_4).to_not be_nil
      end

      it 'should have a matching answer and correct answer' do
        question = Question.from_api(valid_multiple_json)

        answers = [
          question.answer_1,
          question.answer_2,
          question.answer_3,
          question.answer_4
        ]

        expect(answers).to include(question.correct_answer)
      end
    end

    describe 'being passed a true or false question' do
      it 'should return a valid question object' do
        question = Question.from_api(valid_boolean_json)

        expect(question.valid?).to be true
      end

      it 'should have nil for answers 3 and 4' do
        question = Question.from_api(valid_boolean_json)

        expect(question.answer_3).to be_nil
        expect(question.answer_4).to be_nil
      end
    end
  end

  describe "#hash_body" do
    it "should give the same hash each time" do
      old_hash = Question.hash_body(valid_question.body)
      new_hash = Question.hash_body(valid_question.body)
      different_hash = Question.hash_body("random thought")

      expect(new_hash).to eql(old_hash)
      expect(new_hash).to_not eql(different_hash)
    end
  end
end
