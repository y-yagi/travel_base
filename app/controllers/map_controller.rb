class MapController < ApplicationController

  def schedule
    load_travel_date
    return redirect_to root_path if @trave_date.schedules.empty?
    return redirect_to root_path unless @trave_date.travel.member?(current_user.id)

    places = @trave_date.schedules.map(&:place)
    @places_for_map = places.map { |p| { name: p.name, latitude: p.latitude, longitude: p.longitude } }.to_json
    @map_zoom = 12
    render :show
  end

  def places
    places = Place.acquire_by_params(current_user, params)
    @places_for_map = places.map{ |p| { name: p.name, latitude: p.latitude, longitude: p.longitude } }.to_json
    @map_zoom = 7
    render :show
  end

  def place
    place = current_user.places.find(params[:id])
    @places_for_map = [{ name: place.name, latitude: place.latitude, longitude: place.longitude }].to_json
    @map_zoom = 12
    render :show
  end

  private
    def load_travel_date
      @trave_date = TravelDate.eager_load(:schedules, [schedules: :place])
        .merge(Schedule.order(:start_time)).find(params[:travel_date_id])
    end
end
