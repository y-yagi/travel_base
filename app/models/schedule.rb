# == Schema Information
#
# Table name: schedules
#
#  id                 :integer          not null, primary key
#  memo               :text
#  start_time         :time
#  end_time           :time
#  travel_date_id     :integer          not null
#  place_id           :integer          not null
#  route_id           :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  attachment_file_id :string
#

class Schedule < ActiveRecord::Base
  include Api::Schedule

  belongs_to :travel_date, touch: true
  belongs_to :place
  belongs_to :route, optional: true

  validates :travel_date_id, presence: true
  validates :place_id, presence: true
  validate  :already_registered

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
