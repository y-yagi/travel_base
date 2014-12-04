class Travel < ActiveRecord::Base
  include Elasticsearch::Model
  has_many :travel_dates, dependent: :destroy
  has_many :travel_photos, dependent: :destroy

  scope :schedules, -> do
    eager_load(:travel_dates, :travel_photos, travel_dates: :schedules, travel_dates: { schedules: :place })
      .merge(TravelDate.order(:date)).merge(Schedule.order(:start_time))
  end

  before_save :adjust_travel_dates

  class << self
    def build(params)
      travel = new(params)
      travel
    end
  end

  def adjust_travel_dates
    return if start_date > end_date # TODO: これはvalidationでチェックする

    new_date_range = (start_date..end_date)
    unless travel_dates.empty?
      travel_dates.each do |travel_date|
        travel_date.destroy unless new_date_range.include?(travel_date.date)
      end
    end
    old_date_range = travel_dates.map(&:date)
    new_date_range.each do |d|
      self.travel_dates.build({date: d}) unless old_date_range.include?(d)
    end
  end
end
