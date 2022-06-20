class GamesController < ApplicationController
  before_action :retrieve_game, only: [:show, :start, :answer, :continue, :finish, :new_round]

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(create_game_params)

    if @game.valid?
      redirect_to @game
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def start
    @game.with_lock do
      @game.start
      @game.save
    end

    respond_to do |format|
      @game.retrieve_trivia_questions
      format.html { redirect_to @game }
      format.turbo_stream
    end
  end

  def answer
    @game.with_lock do
      @game.answer(answer_params)
      @game.save
    end

    respond_to do |format|
      format.html { redirect_to @game }
      format.turbo_stream
    end
  end

  def continue
    @game.with_lock do
      @game.continue
      @game.save
    end

    respond_to do |format|
      format.html { redirect_to @game }
      format.turbo_stream
    end
  end

  def finish
    @game.with_lock do
      @game.finish
      @game.save
    end

    respond_to do |format|
      format.html { redirect_to @game }
      format.turbo_stream
    end
  end

  def new_round
    new_game = @game.dup
    new_game.game_lifecycle = "configured"
    new_game.current_round = 1
    new_game.save

    if new_game.valid?
      respond_to do |format|
        format.html { redirect_to @game }
        format.turbo_stream
      end
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
    @game = Game.where(channel: params[:channel]).last
  end

  def create_game_params
    if Flipper.enabled? :multiplayer_games
      params.require(:game).permit(:number_of_questions, :category, :difficulty, :game_type, :multiplayer)
    else
      params.require(:game).permit(:number_of_questions, :category, :difficulty, :game_type)
    end
  end

  def answer_params
    params.require(:answer)
  end
end
