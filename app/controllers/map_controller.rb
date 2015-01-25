class MapController < ApplicationController

  def schedule
    @trave_date = TravelDate.eager_load(:schedules).find(params[:travel_date_id])

    return redirect_to root_path if @trave_date.schedules.empty?
    return redirect_to root_path unless @trave_date.travel.member?(current_user.id)

    places = @trave_date.schedules.map(&:place)
    gon.places  = places.map{ |p| { name: p.name, latitude: p.latitude, longitude: p.longitude } }
    gon.zoom = 12
    render :show
  end

  def places
    places = Place.mine(current_user).not_gone
    gon.places  = places.map{ |p| { name: p.name, latitude: p.latitude, longitude: p.longitude } }
    gon.zoom = 7
    render :show
  end

  def place
    place = Place.mine(current_user).find(params[:id])
    gon.places  = [{ name: place.name, latitude: place.latitude, longitude: place.longitude }]
    gon.zoom = 12
    render :show
  end
end
