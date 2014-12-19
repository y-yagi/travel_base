module TravelDecorator
  def schedule
    start_date.to_s + " ~ " + end_date.to_s
  end

  def schedule_list_for_select
    list = {}
    travel_dates.each { |d| list[I18n.l(d.date, format: :long)] = d.id }
    options_for_select(list)
  end

  def photo_list_for_select
    list = {}
    travel_photos.each { |p| list[p.name] = travel_photo_path(p.travel, p) }
    options_for_select(list)
  end
end
