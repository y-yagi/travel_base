class TravelDate < ApplicationRecord
  include Api::TravelDate

  belongs_to :travel, touch: true
  has_many :schedules, -> { order(:start_time) }, dependent: :destroy

  validates :date, presence: true
  validates :travel_id, presence: true

end
