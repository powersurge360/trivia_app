class InvitationsController < ApplicationController
  before_action :enable_controller?

  def index
  end

  def create
    @player = Player.create(player_params)

    if @player.valid?
      redirect_to game_path(@player.game)
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def player_params
    params.require(:player).permit(:username, :join_code)
  end

  def enable_controller?
    render status: :not_found unless Flipper.enabled?(:multiplayer_games)
  end
end
