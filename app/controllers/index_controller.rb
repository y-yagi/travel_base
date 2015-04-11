class IndexController < ApplicationController
  skip_before_action :check_logged_in, :setup

  def index
    dashboard if logged_in?
  end

  def dashboard
    @need_pages_js = true
    setup
    @places = Place.mine(current_user).registered_recently
    future_travels = Travel.schedules.belong(current_user).future
    @next_travel = future_travels.first
    @future_travels = future_travels.map do |t|
      { title: t.name, start: t.start_date, end: t.end_date+ 1 }
    end.to_json
    render :dashboard
  end
end
