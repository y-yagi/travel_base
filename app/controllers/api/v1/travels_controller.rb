class Api::V1::TravelsController < Api::ApplicationController
  include Garage::RestfulActions

  def require_resources
    @resources = ::Travel.belong(current_resource_owner).order('start_date DESC')
  end

  def require_resource
    @resource = ::Travel.schedules.belong(current_resource_owner).find(params[:id])
  end
end
