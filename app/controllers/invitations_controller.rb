class InvitationsController < ApplicationController
  before_action :enable_controller?
  before_action :retrieve_game

  def index
  end

  def create
    @player = @game.players.create(player_params)

    if @player.valid?
      redirect_to game_path(@game)
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def retrieve_game
    @game = Game.where(channel: game_params[:game_channel], game_lifecycle: "lobby_open").last!
  end

  def game_params
    params.permit(:join_code, :game_channel)
  end

  def player_params
    params.require(:player).permit(:username, :join_code)
  end

  def enable_controller?
    render status: :not_found unless Flipper.enabled?(:multiplayer_games)
  end
end
