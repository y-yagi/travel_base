class Api::V1::EventsController < Api::ApplicationController
  include Garage::RestfulActions

  def require_resources
    @resources = if params[:updated_at]
      current_resource_owner.events.order(updated_at: :desc).where('updated_at > ?', params[:updated_at])
    else
      current_resource_owner.events.order(updated_at: :desc)
    end
  end
end
