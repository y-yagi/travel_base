class Place < ActiveRecord::Base

  class << self
    def build(params)
      @place = Place.new(params)
      set_geoinfo(@place) if params[:latitude].blank?
      @place
    end

    def set_geoinfo(place)
      geo_info = Geocoder.search(place.address)
      return if geo_info.empty?

      place.latitude = geo_info.first.geometry['location']['lat']
      place.longitude = geo_info.first.geometry['location']['lng']
    end
  end
end
