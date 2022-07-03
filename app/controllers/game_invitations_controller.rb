class GameInvitationsController < ApplicationController
  before_action :retrieve_game

  def show
  end

  def update
  end

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
end
