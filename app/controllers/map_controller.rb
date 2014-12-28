class MapController < ApplicationController
  layout 'map'

  def schedule
    @trave_date = TravelDate.eager_load(:schedules).find(params[:travel_date_id])
    # TODO check travel member
    return redirect_to root_path if @trave_date.schedules.empty?
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
end
