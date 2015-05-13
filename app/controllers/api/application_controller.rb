class Api::ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include Garage::ControllerHelper

  def current_resource_owner
    @current_resource_owner ||= User.authenticate!(user_id: params[:user_id], provider: params[:user_provider])
  end
end
