class Question < ApplicationRecord
  validates :body, presence: :true
  validates :answer_1, presence: :true
  validates :answer_2, presence: :true
  validates :correct_answer, presence: :true, inclusion: { in: [1, 2, 3, 4] }

  before_validation :ensure_id

  broadcasts_to ->(_) { :questions }

  def self.hash_body(value)
    Digest::SHA256.hexdigest(value)
  end

  private

  def ensure_id
    self.id = Question.hash_body(body)
  end
end
