class Api::V1::UserController < Api::ApplicationController
  def registrate_token
    current_resource_owner.update!(device_token: params[:token])
  end

  def require_resource
    @resource = current_resource_owner
  end
end
