class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  # GET /questions or /questions.json
  def index
    @questions = Question.all
  end

  # GET /questions/1 or /questions/1.json
  def show
  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions or /questions.json
  def create
    begin
      @question = Question.find(Question.hash_body(question_params[:body]))
    rescue ActiveRecord::RecordNotFound
      @question = Question.new(question_params)
    end

    if @question.save
      redirect_to @question, notice: "Question was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /questions/1 or /questions/1.json
  def update
    if @question.update(question_params)
      redirect_to @question, notice: "Question was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /questions/1 or /questions/1.json
  def destroy
    @question.destroy

    redirect_to questions_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def question_params
      values = params.require(:question).permit(:body, :answer_1, :answer_2, :answer_3, :answer_4, :correct_answer)
    end
end
