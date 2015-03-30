class PlacesStation < ActiveRecord::Base
  belongs_to :place
  belongs_to :station
end
