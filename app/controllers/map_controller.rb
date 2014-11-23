class MapController < ApplicationController
  layout false
  def show
    @trave_date = TravelDate.eager_load(:schedules).find(params[:travel_date_id])
    return redirect_to root_path if @trave_date.schedules.empty?
    @first_place = @trave_date.schedules.first.place
  end
end
