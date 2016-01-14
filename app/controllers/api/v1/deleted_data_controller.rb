class Api::V1::DeletedDataController < Api::ApplicationController
  include Garage::RestfulActions

  def require_resources
    @resources = if params[:updated_at]
      ::DeletedDatum.mine(current_resource_owner).where('updated_at > ?', params[:updated_at])
    else
      ::DeletedDatum.mine(current_resource_owner)
    end
  end
end
