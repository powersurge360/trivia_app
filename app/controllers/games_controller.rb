class GamesController < ApplicationController
  before_action :retrieve_game, only: [:show, :start, :answer, :continue, :finish]

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
    @game.start
    @game.save
  end

  def answer
    @game.answer(answer_params)
    @game.save
  end

  def continue
    @game.continue
    @game.save
  end

  def finish
    @game.finish
    @game.save
  end

  private

  def retrieve_game
    @game = Game.includes(:questions, :game_questions).find(params[:id])
  end

  def create_game_params
    params.require(:game).permit(:number_of_questions, :category, :difficulty, :game_type)
  end

  def answer_params
    params.require(:answer)
  end
end
