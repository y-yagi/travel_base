class SessionsController < ApplicationController
  skip_before_filter :check_logged_in, :setup
  layout 'no_menu'

  def new
  end

  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    session[:user_id] = @user.id
    redirect_to root_path
  end

  protected
    def auth_hash
      request.env['omniauth.auth']
    end
end
