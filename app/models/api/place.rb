module Api::Place
  extend ActiveSupport::Concern

  included do
    include Garage::Representer
    property :id
    property :name
    property :address
    property :memo
    property :latitude
    property :longitude
    property :station_info
    property :url

    def station_info
      places_station.each.sum do |ns|
        "#{ns.station.line} #{ns.station.name}駅 #{ns.distance}\n"
      end
    end

    def url
      urls.try(:join, ",").to_s
    end
  end
end
