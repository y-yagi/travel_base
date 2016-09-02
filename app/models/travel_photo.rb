# == Schema Information
#
# Table name: travel_photos
#
#  id                         :integer          not null, primary key
#  name                       :string           not null
#  travel_id                  :integer
#  photo_service_user_info_id :integer
#  photo_service_album_id     :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

class TravelPhoto < ApplicationRecord
  belongs_to :travel
  belongs_to :photo_service_user_info

  validates :name, presence: true
  validates :travel_id, presence: true
  validates :photo_service_album_id, presence: true
end
