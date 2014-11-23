class Travel < ActiveRecord::Base
  include Elasticsearch::Model
  has_many :travel_dates

  scope :schedules, -> do
    eager_load(:travel_dates, travel_dates: :schedules, travel_dates: { schedules: :place })
      .merge(Schedule.order(:start_time))
  end

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
