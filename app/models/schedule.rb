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
  belongs_to :travel_date
  belongs_to :place
  belongs_to :route

  validates :travel_date_id, presence: true
  validates :place_id, presence: true
  validate  :already_registered

  class << self
    def build(params)
      new(params)
    end
  end

  def already_registered
    return if self.travel_date.blank? || !place_id_changed?

    exists = Schedule.includes(:travel_date).references(:travel_date)
      .where('travel_dates.travel_id = ? AND place_id = ?', self.travel_date.travel_id, self.place_id)
      .exists?

    errors.add(:place, :taken) if exists
  end
end
