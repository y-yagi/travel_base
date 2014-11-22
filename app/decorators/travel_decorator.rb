module TravelDecorator
  def schedule
    start_date.to_s + " ~ " + end_date.to_s
  end

  def schedule_list_for_select
    list = {}
    travel_dates.each { |d| list[I18n.l(d.date, format: :long)] = d.id }
    options_for_select(list)
  end
end
