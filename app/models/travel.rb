class Travel < ApplicationRecord
  include Api::Travel
  include Recorder

  has_many :travel_dates, -> { order(:date) },  dependent: :destroy
  has_many :travel_photos, dependent: :destroy
  has_many :dropbox_files, dependent: :destroy
  has_many :todos, dependent: :destroy
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

  accepts_nested_attributes_for :dropbox_files, :travel_dates

  scope :schedules, -> do
    eager_load(:travel_dates, travel_dates: { schedules: [:place, :route] })
      .merge(TravelDate.order(:date)).merge(Schedule.order(:start_time))
  end
  scope :mine, ->(user) { where(owner_id: user.id) }
  scope :belong, ->(user) do
    where('members @> ARRAY[?]::integer[] OR owner_id = ?', [user.id], user.id)
  end
  scope :future, -> do
    where('end_date >= ?', Date.current)
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

    def archive_places!
      ended_travels = Travel.where(end_date: Time.zone.yesterday.to_date)
      return if ended_travels.empty?

      ended_travels.each do |travel|
        travel.places.each do |place|
          next unless place.user.auto_archive?
          place.already_went!
        end
      end
    end
  end

  def adjust_travel_dates
    remove_erased_dates!
    build_new_dates
  end

  def member?(user_id)
    return false unless members
    members.include?(user_id) || owner_id == user_id
  end

  def owner?(user)
    owner_id == user.id
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

  def places
    travel_dates.map { |date| date.schedules.map(&:place) }.flatten
  end

  private
    def remove_erased_dates!
      if travel_dates.present?
        travel_dates.where.not(date: date_range).each(&:destroy!)
      end
    end

    def build_new_dates
      old_date_range = travel_dates.map(&:date)
      date_range.reject { |d| old_date_range.include?(d) }.each do |d|
        self.travel_dates.build({ date: d })
      end
    end
end
