class CspReportsController < ActionController::Base
  skip_forgery_protection

  def create
    Rails.logger.info(params["csp-report"])
    Rollbar.error("CSP report", report: params["csp-report"])
    head :ok
  end
end
