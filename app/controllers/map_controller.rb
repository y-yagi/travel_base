class MapController < ApplicationController
  layout false

  def schedule
    @trave_date = TravelDate.eager_load(:schedules).find(params[:travel_date_id])
    return redirect_to root_path if @trave_date.schedules.empty?

    @places = @trave_date.schedules.map(&:place)
    render :show
  end

  def places
    # TODO: scope by user
    @places = Place.all
    @zoom = 7
    render :show
  end
end
