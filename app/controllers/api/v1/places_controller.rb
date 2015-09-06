class Api::V1::PlacesController < Api::ApplicationController
  include Garage::RestfulActions

  def require_resources
    @resources = ::Place.mine(current_resource_owner).not_gone.order('updated_at DESC')
  end
end
