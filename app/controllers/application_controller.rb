class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :check_logged_in, :setup
  add_flash_types :info, :warning, :danger

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !current_user.nil?
  end

  def check_logged_in
    redirect_to login_path unless logged_in?
  end

  def setup
    @travels = Travel.belong(current_user).future
  end

  def set_page_js
    @need_pages_js = true
  end
end
