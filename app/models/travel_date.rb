# == Schema Information
#
# Table name: travel_dates
#
#  id         :integer          not null, primary key
#  date       :date             not null
#  travel_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TravelDate < ActiveRecord::Base
  include Api::TravelDate

  belongs_to :travel
  has_many :schedules, -> { order(:start_time) }, dependent: :destroy

  validates :date, presence: true
  validates :travel_id, presence: true

end
