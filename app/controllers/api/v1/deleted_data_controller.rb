class Api::V1::DeletedDataController < Api::ApplicationController
  include Garage::RestfulActions

  def require_resources
    @resources = if params[:updated_at]
      current_resource_owner.deleted_data.where('updated_at > ?', params[:updated_at])
    else
      current_resource_owner.deleted_data
    end
  end
end
