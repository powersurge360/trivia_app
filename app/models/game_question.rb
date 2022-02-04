class GameQuestion < ApplicationRecord
  belongs_to :game
  belongs_to :question
end
