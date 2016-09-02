# == Schema Information
#
# Table name: places_stations
#
#  place_id   :integer          not null
#  station_id :integer          not null
#  distance   :string
#

class PlacesStation < ApplicationRecord
  belongs_to :place
  belongs_to :station

  class << self
    def build_from_api_result!(place, stations)
      transaction do
        stations['response']['station'].each do |station|
          new_station = Station.find_or_create_by!(
            name: station['name'],
            line: station['line'],
            latitude: station['y'],
            longitude: station['x']
          )
          self.create!(place: place, station: new_station, distance: station['distance'])
        end
      end
    end
  end
end
