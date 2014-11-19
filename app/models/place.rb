class Place < ActiveRecord::Base

  class << self
    def build(params)
      @place = Place.new(params)
      set_geoinfo(@place)
      @place
    end

    def set_geoinfo(place)
      geo_info = Geocoder.search(place.address)
      # TODO: first決め打ちで問題無いか確認する
      place.latitude = geo_info.first.geometry['location']['lat']
      place.longitude = geo_info.first.geometry['location']['lng']
    end
  end
end
