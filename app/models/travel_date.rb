class TravelDate < ActiveRecord::Base
  belongs_to :travel, dependent: :destroy
end
