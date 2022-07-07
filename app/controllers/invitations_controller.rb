class InvitationsController < ApplicationController
  before_action :retrieve_game
  before_action :enable_controller?

  def index
  end

  def create
  end

  private

  def retrieve_game
    eligible_games = Game.where(channel: params[:channel])

    if game_params[:join_code].present?
      game_id = Game.decode_hash_id(params[:join_code])
      @game = eligible_games.find(game_id)
    else
      @game = eligible_games.where(game_params[:channel])
    end
  end

  def game_params
    params.permit(:join_code)
  end

  def enable_controller?
    render status: :not_found unless Flipper.enabled? :multiplayer_games
  end
end
