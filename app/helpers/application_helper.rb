module ApplicationHelper
  def googlemap_link(address)
    "https://www.google.co.jp/maps/?q=#{CGI.escape(address)}"
  end

  def googlemap_route_link(from, to)
    "https://www.google.co.jp/maps/dir/#{CGI.escape(from)}/#{CGI.escape(to)}"
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

  def assets_exist?(asset)
    if Rails.application.config.assets.compile
      Rails.application.assets[asset]
    else
      Rails.application.assets_manifest.assets[asset]
    end
  end
end
