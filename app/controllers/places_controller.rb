class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy, :archive]
  before_action :set_page_js, only: [:new, :show, :edit, :update]

  def index
    @places = Place.acquire_by_params(current_user, params)
    fresh_when(@places)
  end

  def show
    @need_pages_js = true
    @places_for_map  = [{ name: @place.name, latitude: @place.latitude, longitude: @place.longitude }].to_json
    @map_zoom = 12
  end

  def new
    @need_pages_js = true
    @place = Place.new

    @places = params[:query].present? ? Geocoder.search(params[:query]) : []
  end

  def edit
  end

  def create
    @place = Place.build(place_params, current_user)
    if @place.save
      @place.set_station_info
      redirect_to places_url, info: %("#{@place.name}"を登録しました)
    else
      render :new
    end
  end

  def update
    if @place.update(place_params)
      redirect_to places_url, info: %("#{@place.name}"の情報を更新しました)
    else
      render :edit
    end
  end

  def destroy
    @place.destroy
    redirect_to places_url, info: %("#{@place.name}"を削除しました)
  end

  def archive
    @place.update!(status: :already_went)
    redirect_to places_url, info: %("#{@place.name}"をアーカイブしました), change: 'places'
  end

  private
    def set_place
      @place = current_user.places.find(params[:id])
    end

    def place_params
      params[:place][:tags] = params[:place][:tags].split(',') if params[:place][:tags]
      params.require(:place).permit(:name, :address, :status,
        :memo, :latitude, :longitude, :website, urls: [], tags: [])
    end
end
