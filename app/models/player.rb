class Player < ApplicationRecord
  attr_accessor :join_code

  validates :channel, presence: true
  validates :username, presence: true, uniqueness: {scope: :channel}
  validates :join_code, presence: true, unless: :host
  validate :join_code_matches_game, on: :create, unless: :host

  before_validation :ensure_channel, on: :create

  # This describes a relation to a series of games marked off by channel rather
  # than a specific game
  belongs_to :game,
    # Only grab the latest game
    -> { limit(1) },
    foreign_key: :channel,
    primary_key: :channel

  private

  def ensure_channel
    return unless join_code.present?

    self.channel = Game
      .open_lobby
      .find_by(id: Game.decode_hash_id(join_code))
      &.channel
  end

  def join_code_matches_game
    if channel.nil?
      return errors.add(:join_code, "must be valid")
    end

    hash_id = Game.open_lobby.latest_round(channel: channel).last&.encode_hash_id

    if hash_id != join_code
      errors.add(:join_code, "must be valid")
    end
  end
end
