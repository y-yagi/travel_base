module IndexHelper
  def get_place_name_from_geocode_result(place)
    place.address_components.first['long_name']
  end
end
