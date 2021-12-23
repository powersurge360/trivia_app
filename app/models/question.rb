class Question < ApplicationRecord
  validates :body, presence: :true
  validates :answer_1, presence: true
  validates :answer_2, presence: true
  validates :correct_answer, presence: true
  validates :difficulty, presence: true, inclusion: { in: ["easy", "medium", "hard"] }

  before_validation :ensure_id

  def self.from_api(question_json)
    if question_json["type"] == "multiple"
      answers = question_json["incorrect_answers"].append(question_json["correct_answer"]).shuffle
    else
      answers = ["True", "False", nil, nil]
    end

    new(
      body: question_json["question"],
      difficulty: question_json["difficulty"],
      answer_1: answers[0],
      answer_2: answers[1],
      answer_3: answers[2],
      answer_4: answers[3],
      correct_answer: question_json["correct_answer"]
    )
  end

  def self.hash_body(value)
    Digest::SHA256.hexdigest(value)
  end

  private

  def ensure_id
    self.id = Question.hash_body(body)
  end
end
