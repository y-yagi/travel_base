# == Schema Information
#
# Table name: travels
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  memo       :text
#  start_date :date
#  end_date   :date
#  deleted_at :datetime
#  owner_id   :integer          not null
#  members    :integer          is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Travel < ActiveRecord::Base
  include Elasticsearch::Model
  has_many :travel_dates, dependent: :destroy
  has_many :travel_photos, dependent: :destroy
  has_one :owner, through: :user

  scope :schedules, -> do
    eager_load(:travel_dates, :travel_photos, travel_dates: :schedules, travel_dates: { schedules: :place })
      .merge(TravelDate.order(:date)).merge(Schedule.order(:start_time))
  end
  scope :mine, ->(user) { where(owner_id: user.id) }

  before_save :adjust_travel_dates

  class << self
    def build(params, user)
      travel = new(params)
      travel.owner_id = user.id
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

  def travel_member?(user_id)
    return false unless members
    members.include?(user_id)
  end
end
