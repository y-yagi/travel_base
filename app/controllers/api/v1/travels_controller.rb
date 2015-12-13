class Api::V1::TravelsController < Api::ApplicationController
  include Garage::RestfulActions

  def require_resources
    @resources = if params[:updated_at]
      ::Travel.belong(current_resource_owner).order('start_date DESC').where('updated_at > ?', params[:updated_at])
    else
      ::Travel.belong(current_resource_owner).order('start_date DESC')
    end
  end

  def require_resource
    @resource = ::Travel.schedules.belong(current_resource_owner).find(params[:id])
  end
end
