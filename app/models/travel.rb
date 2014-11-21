class Travel < ActiveRecord::Base
  has_many :travel_dates

  class << self
    def build(params)
      travel = new(params)
      return if travel.start_date > travel.end_date

      (travel.start_date..travel.end_date).each do |d|
        travel.travel_dates.build({date: d})
      end
      travel
    end
  end
end
