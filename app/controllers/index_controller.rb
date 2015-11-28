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
    future_travels_for_calendar = future_travels.map do |t|
      { title: t.name, start: t.start_date, end: t.end_date + 1 }
    end

    @events = (future_travels_for_calendar + build_holidays_for_calendar).to_json
    render :dashboard
  end

  def build_holidays_for_calendar
    HolidayJp.between(Date.current, 1.year.since).map do |h|
      { title: h.name, start: h.date, color: 'orange' }
    end
  end
end
