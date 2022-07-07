class Game::Invitation < ApplicationRecord
  include ActiveModel::Validations
  attr_accessor :username, :channel, :join_code

  validates :username, presence: true
  validates :channel, presence: true
  validates :join_code, presence: true
end
