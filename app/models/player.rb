class Player < ApplicationRecord
  attr_accessor :join_code

  validates :channel, presence: true
  validates :username, presence: true, uniqueness: {scope: :channel}
  validates :join_code, presence: true
  validate :join_code_matches_game, on: :create

  # This describes a relation to a series of games marked off by channel rather
  # than a specific game
  belongs_to :game,
    # Only grab the latest game
    -> { limit(1) },
    foreign_key: :channel,
    primary_key: :channel

  private

  def join_code_matches_game
    if channel.nil?
      return errors.add(:join_code, "A game matching this join code cannot be found")
    end

    hash_id = Game.latest_round(channel: channel).last.encode_hash_id

    if hash_id != join_code
      errors.add(:join_code, "A game matching this join code cannot be found")
    end
  end
end
