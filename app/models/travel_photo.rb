class TravelPhoto < ApplicationRecord
  belongs_to :travel
  belongs_to :photo_service_user_info

  validates :name, presence: true
  validates :travel_id, presence: true
  validates :photo_service_album_id, presence: true
end
