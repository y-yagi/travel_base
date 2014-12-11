class Place < ActiveRecord::Base
  include Elasticsearch::Model

  class << self
    def build(params, user)
      place = new(params)
      place.user_id = user.id
      set_geoinfo(place) if params[:latitude].blank?
      place
    end

    def set_geoinfo(place)
      geo_info = Geocoder.search(place.address)
      return if geo_info.empty?

      place.latitude = geo_info.first.geometry['location']['lat']
      place.longitude = geo_info.first.geometry['location']['lng']
    end
  end
end
