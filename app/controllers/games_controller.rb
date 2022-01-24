class GamesController < ApplicationController
  before_action :retrieve_game, only: [:show, :start]

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(create_game_params)

    if @game.valid?
      @game.retrieve_trivia_questions

      redirect_to @game
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def start
    @game.game_lifecycle = "running"
    @game.save

    if @game.valid?
      redirect_to @game
    end
  end

  private

  def retrieve_game
    @game = Game.includes(:questions).find(params[:id])
  end

  def create_game_params
    params.require(:game).permit(:number_of_questions, :category, :difficulty, :game_type)
  end
end
