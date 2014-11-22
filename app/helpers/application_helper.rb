module ApplicationHelper
  def get_place_name_from_geocode_result(place)
    place.address_components.first['long_name']
  end

  def get_address_form_geocode_result(place)
    # 最初の国名が含まれるので、国名のみ削除する
    place.formatted_address.split(' ', 2).second
  end

  def googlemap_link(address)
    URI.encode("https://maps.google.co.jp/maps?q=#{address}")
  end

  def default_schedule_start_time

  end
end
