class IndexController < ApplicationController
  def index
    @places = Place.mine(current_user).order('created_at DESC')
    @future_travels = Travel.schedules.belong(current_user).future
    gon.events = if @future_travels.present?
                      @future_travels.map do |t|
                        { title: t.name, start: t.start_date, end: t.end_date + 1 }
                      end
                  else
                    {}
                  end
  end
end
