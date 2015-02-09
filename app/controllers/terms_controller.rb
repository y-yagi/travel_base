class TermsController < ApplicationController
  skip_before_filter :check_logged_in, :setup
  def index
  end
end
