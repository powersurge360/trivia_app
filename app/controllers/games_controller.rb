class GamesController < ApplicationController
  before_action :retrieve_game, only: [:show, :start, :answer, :continue, :finish, :new_round]

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

  def new_round
    new_game = @game.dup
    new_game.game_lifecycle = "pending"
    new_game.current_round = 1
    new_game.save

    if new_game.valid?
      new_game.retrieve_trivia_questions
    else
      logger.error("Failed to start a new round: #{@game.to_json}")
      redirect_to new_game_path
    end
  end

  def logger
    tagged_logger = super

    if @game&.id
      tagged_logger.tagged("Game ID: #{@game.id}")
    else
      tagged_logger
    end
  end

  private

  def retrieve_game
    @game = Game.includes(:questions, :game_questions).order(updated_at: :desc).find_by(channel: params[:channel])
  end

  def create_game_params
    params.require(:game).permit(:number_of_questions, :category, :difficulty, :game_type)
  end

  def answer_params
    params.require(:answer)
  end
end
