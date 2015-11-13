class LivesController < ApplicationController
  before_action :set_life, only: [:show, :edit, :update, :destroy, :cycle]

  # GET /lives
  def index
    @lives = Life.all
  end

  # GET /lives/1
  def show
  end

  # GET /lives/new
  def new
    @life = Life.new
    @new = true
  end

  # GET /lives/1/edit
  def edit
  end

  # POST /lives
  def create
    @life = Life.new(life_params)

    if @life.save
      redirect_to @life, notice: 'Life was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /lives/1
  def update
    if @life.update(life_params)
      redirect_to @life, notice: 'Life was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /lives/1
  def destroy
    @life.destroy
    redirect_to lives_url, notice: 'Life was successfully destroyed.'
  end

  ## NON-CRUD
  def cycle
    @life.cycle!
    render :show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_life
      @life = Life.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def life_params
      params.require(:life).permit(:width, :height, :name)
    end
end
