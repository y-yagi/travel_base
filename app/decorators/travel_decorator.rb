module TravelDecorator
  def formatted_schedule
    I18n.l(start_date, format: :long)  + " 〜 " + I18n.l(end_date, format: :long)
  end

  def schedule_list_for_select(selected: nil)
    list = {}
    travel_dates.each { |d| list[I18n.l(d.date, format: :long)] = d.id }
    options_for_select(list, selected)
  end

  def generate_invite_url
    new_travel_member_url(travel_id: id, key: generate_invite_key)
  end
end
