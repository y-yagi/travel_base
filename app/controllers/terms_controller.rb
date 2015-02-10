class TermsController < ApplicationController
  skip_before_action :check_logged_in, :setup
  def index
  end
end
