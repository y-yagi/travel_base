class Schedule < ApplicationRecord
  include Api::Schedule

  belongs_to :travel_date, touch: true
  belongs_to :place
  belongs_to :route, optional: true

  validates :travel_date_id, presence: true
  validates :place_id, presence: true
  validate  :already_registered

  enum purpose: { sightseeing: 0, move: 1, other: 99 }

  class << self
    def build(params)
      new(params)
    end

    def convert_datetime_to_time(datetime)
      datetime.change(year: 2000, day: 1, month: 1) + 9.hours
    end

    def start_time_in(begin_time, end_time)
      converted_begin = convert_datetime_to_time(begin_time)
      converted_end = convert_datetime_to_time(end_time)
      where(start_time: converted_begin..converted_end)
    end
  end

  def already_registered
    return if self.travel_date.blank? || !place_id_changed?

    exists = Schedule.
      where('travel_date_id = ? AND place_id = ?', self.travel_date.id, self.place_id).exists?

    errors.add(:place, :taken) if exists
  end
end
