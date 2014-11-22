class TravelsController < ApplicationController
  before_action :set_travel, only: [:edit, :update, :destroy]

  def index
    @travels = Travel.all
  end

  def show
    # TODO: limit by user
    @places = Place.pluck(:name, :id)
    @travel = Travel.schedules.find(params[:id])
  end

  def new
    @travel = Travel.new
  end

  def edit
  end

  def create
    @travel = Travel.build(travel_params)

    respond_to do |format|
      if @travel.save
        format.html { redirect_to @travel, notice: 'Travel was successfully created.' }
        format.json { render :show, status: :created, location: @travel }
      else
        format.html { render :new }
        format.json { render json: @travel.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @travel.update(travel_params)
        format.html { redirect_to @travel, notice: 'Travel was successfully updated.' }
        format.json { render :show, status: :ok, location: @travel }
      else
        format.html { render :edit }
        format.json { render json: @travel.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @travel.destroy
    respond_to do |format|
      format.html { redirect_to travels_url, notice: 'Travel was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_travel
      @travel = Travel.find(params[:id])
    end

    def travel_params
      params.require(:travel).permit(:name, :memo, :start_date, :end_date, :deleted_at, :user_id)
    end
end
