class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy]

  def search
    @places = []
    if params[:query]
      @places = Geocoder.search(params[:query])
      @place = Place.new
    end
  end

  def index
    @places = Place.all
  end

  def show
  end

  def new
    @place = Place.new
    @places = []
  end

  def edit
  end

  def create
    @place = Place.build(place_params)
    respond_to do |format|
      if @place.save
        flash[:info] ='Place was successfully created.'
        format.html { redirect_to places_url }
        format.json { render :show, status: :created, location: @place }
      else
        format.html { render :new }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @place.update(place_params)
        flash[:info] ='Place was successfully updated.'
        format.html { redirect_to places_url }
        format.json { render :show, status: :ok, location: @place }
      else
        format.html { render :edit }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @place.destroy
    respond_to do |format|
      flash[:info] ='Place was successfully destroyed.'
      format.html { redirect_to places_url }
      format.json { head :no_content }
    end
  end

  private
    def set_place
      @place = Place.find(params[:id])
    end

    def place_params
      params.require(:place).permit(:name, :address, :memo, :latitude, :longitude, :website, :deleted_at, :user_id)
    end
end
