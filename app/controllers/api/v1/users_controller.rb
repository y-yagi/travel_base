class Api::V1::UsersController < Api::ApplicationController
  include Garage::RestfulActions

  def require_resource
    @resource = current_resource_owner
  end

  def update_resource
    current_resource_owner.update!(device_token: params[:token])
  end
end
