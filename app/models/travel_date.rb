class TravelDate < ActiveRecord::Base
  belongs_to :travel
  has_many :schedules, dependent: :destroy
end
