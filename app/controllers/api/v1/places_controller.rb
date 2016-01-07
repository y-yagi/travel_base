class Api::V1::PlacesController < Api::ApplicationController
  include Garage::RestfulActions

  def require_resources
    @resources = if params[:updated_at]
      ::Place.mine(current_resource_owner).includes(places_station: :station).order(updated_at: :desc).where('updated_at > ?', params[:updated_at])
    else
      ::Place.mine(current_resource_owner).includes(places_station: :station).order(updated_at: :desc)
    end
  end

  def create_resource
    @resource = ::Place.create!(
      name: params[:name], address: params[:address],
      latitude: params[:latitude], longitude: params[:longitude],
      user_id: current_resource_owner.id
    )
    @resource.set_station_info
    @resource
  end
end
