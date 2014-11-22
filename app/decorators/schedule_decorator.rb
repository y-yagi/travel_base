module ScheduleDecorator
  def formatted_time
    start_time.strftime("%H:%M") + " 〜 " + end_time.strftime("%H:%M")
  end
end
