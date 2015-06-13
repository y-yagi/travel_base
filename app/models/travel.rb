# == Schema Information
#
# Table name: travels
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  memo       :text
#  start_date :date
#  end_date   :date
#  owner_id   :integer          not null
#  members    :integer          is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Travel < ActiveRecord::Base
  include Elasticsearch::Model
  include Api::Travel

  has_many :travel_dates, dependent: :destroy
  has_many :travel_photos, dependent: :destroy
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

  scope :schedules, -> do
    eager_load(:travel_dates, :travel_photos, travel_dates: { schedules: [:place, :route] })
      .merge(TravelDate.order(:date)).merge(Schedule.order(:start_time))
  end
  scope :mine, ->(user) { where(owner_id: user.id) }
  scope :belong, ->(user) do
    where('members @> ARRAY[?]::integer[] OR owner_id = ?', [user.id], user.id)
  end
  scope :future, -> do
    where('end_date >= ?', Time.now.to_date)
  end

  before_save :adjust_travel_dates

  validates :name, presence: true, length: { maximum: 255 }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :owner_id, presence: true
  validates_with TravelDateValidator

  paginates_per 10

  class << self
    def build(params, user)
      travel = new(params)
      travel.owner_id = user.id
      travel.members = [user.id]
      travel
    end
  end

  def adjust_travel_dates
    unless travel_dates.empty?
      travel_dates.where.not(date: date_range).each(&:destroy!)
    end

    old_date_range = travel_dates.map(&:date)
    date_range.reject { |d| old_date_range.include?(d) }.each do |d|
      self.travel_dates.build({ date: d })
    end
  end

  def member?(user_id)
    return false unless members
    members.include?(user_id) || owner_id == user_id
  end

  def owner?(user_id)
    owner_id == user_id
  end

  def past?
    Time.now.to_date > end_date
  end

  def date_range
    start_date..end_date
  end

  def to_ics
    cal = Icalendar::Calendar.new
    cal.event do |e|
      e.dtstart     = Icalendar::Values::Date.new(start_date)
      e.dtend       = Icalendar::Values::Date.new(end_date)
      e.summary     = name
      e.description = memo
    end
    cal.to_ical
  end

  def generate_invite_key
    message_verifier = Rails.application.message_verifier(:travel_members)
    message_verifier.generate(self.id)
  end

  def valid_invite_key?(key)
    travel_id = Rails.application.message_verifier(:travel_members).verify(key)
    self.id == travel_id
  end
end
