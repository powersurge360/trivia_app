class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    @game = Game.create

    if @game.valid?
      @game.retrieve_trivia_questions

      redirect_to @game
    end
  end

  def show
    @game = Game.find(params[:id])
  end

  private

  def game_params
    params.require(:game).permit(:number_of_questions, :category, :difficulty)
  end
end
