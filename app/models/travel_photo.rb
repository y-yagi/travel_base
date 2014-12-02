class TravelPhoto < ActiveRecord::Base
  belongs_to :travel
  belongs_to :photo_service_user_info
end
