module ApplicationHelper
  def get_place_name_from_geocode_result(place)
    place.address_components.first['long_name']
  end

  def googlemap_link(address)
    URI.encode("https://www.google.co.jp/maps/?q=#{address}")
  end

  def googlemap_route_link(from, to)
    URI.encode("https://www.google.co.jp/maps/dir/#{from}/#{to}")
  end

  def current_menu?(name)
    controller_name == name
  end

  def create_route_title_from_schedules(schedules, index)
    route_title = ''
    if index != 0 && before_schedule = schedules[index - 1]
      route_title = before_schedule.place.name
    end
    route_title + '〜' + schedules[index].place.name
  end

  def create_route_link_from_travel_date(travel_date, index)
    from = index.zero? ? '' : travel_date.schedules[index - 1].place.address
    to = travel_date.schedules[index].place.address
    googlemap_route_link(from, to)
  end

  def generate_invite_url(travel)
    new_travel_member_url(travel_id: travel.id, key: travel.generate_invite_key)
  end
end
