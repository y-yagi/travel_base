module TravelDecorator
  def formatted_schedule
    I18n.l(start_date, format: :long)  + " 〜 " + I18n.l(end_date, format: :long)
  end

  def schedule_list_for_select(selected: nil)
    list = {}
    travel_dates.each { |d| list[I18n.l(d.date, format: :long)] = d.id }
    options_for_select(list, selected)
  end

  def photo_list_for_select
    list = {}
    travel_photos.each { |p| list[p.name] = travel_photo_path(p.travel, p) }
    options_for_select(list)
  end
end
