class PracticesController < ApplicationController
  before_action :set_practice, only: [:show, :edit, :update, :destroy]
  before_action :set_practices, only: [:category]
  before_action :authenticate_user!
  # GET /practices
  # GET /practices.json
  def index
    @practices = Practice.all
  end

  # GET /practices/1
  # GET /practices/1.json
  def show
    @practice = Practice.find(params[:id])

    #Desordena todas las opciones para mostrar en la vista
    @options_array = []
    @practice.questions.each do |question|
      @temp_array = []
      @temp_array << question.correct
      @temp_array << question.incorrect1
      @temp_array << question.incorrect2
      @temp_array << question.incorrect3
      @temp_array = @temp_array.shuffle
      @options_array << @temp_array
    end
    #para iterar sobre las opciones en la vista
    @cont = 0
    puts @options_array[0]
  end

  # GET /practices/new
  def new
    @practice = Practice.new
    @lessons = current_user.lessons.select(:id,:name)
  end

  # GET /practices/1/edit
  def edit
    @lessons = current_user.lessons.select(:id,:name)
  end

  def category
  end

  # POST /practices
  # POST /practices.json
  def create
    @practice = Practice.new(practice_params)
    @lessons = current_user.lessons.select(:id,:name)
    @lesson = Lesson.find(practice_params["lesson_id"])
    @practice.category = @lesson.category

    respond_to do |format|
      if @practice.save
        format.html { redirect_to new_question_path(practice_id: @practice.id), notice: 'Practice was successfully created.' }
        format.json { render :show, status: :created, location: @practice }
      else
        format.html { render :new }
        format.json { render json: @practice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /practices/1
  # PATCH/PUT /practices/1.json
  def update
    respond_to do |format|
      if @practice.update(practice_params)
        format.html { redirect_to new_question_path(practice_id: @practice.id), notice: 'Practice was successfully updated.' }
        format.json { render :show, status: :ok, location: @practice }
      else
        format.html { render :edit }
        format.json { render json: @practice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /practices/1
  # DELETE /practices/1.json
  def destroy
    @practice.destroy
    
    respond_to do |format|
      format.html { redirect_to "/practices/category/all", notice: 'Practice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_practices
      if (params[:category] == "all")
        @practices = Practice.all.order("created_at desc")
      else
        @practices = Practice.where(category: params[:category]).order("created_at desc")
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_practice
      @practice = Practice.find(params[:id])
      @questions = @practice.questions
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def practice_params
      params.require(:practice).permit(:title, :category, :description, :lesson_id)
    end
end