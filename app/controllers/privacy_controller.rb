class PrivacyController < ApplicationController
  skip_before_action :check_logged_in, :setup

  def index
    render layout: false if params[:without_layout]
  end
end
