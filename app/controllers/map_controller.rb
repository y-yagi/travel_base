class MapController < ApplicationController

  def schedule
    travel_dates = load_travel_dates
    return redirect_to root_path if travel_dates.schedules.empty?
    return redirect_to root_path unless travel_dates.travel.member?(current_user.id)

    places = travel_dates.schedules.map(&:place)
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
    def load_travel_dates
      TravelDate.eager_load(:schedules, [schedules: :place])
        .merge(Schedule.order(:start_time)).find(params[:travel_date_id])
    end
end
