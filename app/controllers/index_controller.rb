class IndexController < ApplicationController
  skip_before_action :check_logged_in, :setup

  def index
    dashboard if logged_in?
  end

  def dashboard
    @need_pages_js = true
    setup
    @places = current_user.places.registered_recently
    future_travels = Travel.schedules.belong(current_user).future
    @next_travel = future_travels.first
    future_travels_for_calendar = future_travels.map do |t|
      { title: t.name, start: t.start_date, end: t.end_date + 1 }
    end

    @events = (future_travels_for_calendar + holidays_for_calendar + events_for_calendar).to_json
    render :dashboard
  end

  def holidays_for_calendar
    HolidayJp.between(Date.current, 1.year.since).map do |h|
      { title: h.name, start: h.date, color: 'orange' }
    end
  end

  def events_for_calendar
    current_user.events.future.map do |e|
      { title: e.name, start: e.start_date, end: e.end_date, color: 'DarkCyan' }
    end
  end
end
