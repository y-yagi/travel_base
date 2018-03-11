class CspReportsController < ActionController::Base
  skip_forgery_protection

  def create
    csp = JSON.parse(request.body.read)["csp-report"]
    head :ok
  end
end
