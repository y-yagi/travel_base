module TravelDecorator
  def schedule
    start_date.to_s + " ~ " + end_date.to_s
  end
end
