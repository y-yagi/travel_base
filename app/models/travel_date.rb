class TravelDate < ActiveRecord::Base
  belongs_to :travel, dependent: :destroy
  has_many :schedules
end
