class Api::V1::PlacesController < Api::ApplicationController
  include Garage::RestfulActions

  def require_resources
    @resources = if params[:updated_at]
      current_resource_owner.places.includes(places_station: :station).order(updated_at: :desc).where('updated_at > ?', params[:updated_at])
    else
      current_resource_owner.places.includes(places_station: :station).order(updated_at: :desc)
    end
  end

  def create_resource
    @resource = Place.create_from_params!(params: params, current_resource_owner: current_resource_owner)
  end
end
