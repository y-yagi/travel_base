module ApplicationHelper
  def get_place_name_from_geocode_result(place)
    place.address_components.first['long_name']
  end

  def get_address_form_geocode_result(place)
    # 最初の国名が含まれるので、国名のみ削除する
    # また、郵便番号が含まれる場合、郵便番号も削除
    place.formatted_address.split(' ', 2).second.gsub(/^〒[0-9-]+ /, '')
  end

  def googlemap_link(address)
    URI.encode("https://maps.google.co.jp/maps?q=#{address}")
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
end
