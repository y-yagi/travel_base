class CspReportsController < ActionController::Base
  skip_forgery_protection

  def create
    Rails.logger.info(params["csp-report"])
    head :ok
  end
end
