class Api::V1::UsersController < Api::ApplicationController
  include Garage::RestfulActions

  def require_resource
    @resource = current_resource_owner
  end
end
