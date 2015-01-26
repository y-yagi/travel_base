module ScheduleDecorator
  def formatted_time
    return if start_time.blank? && end_time.blank?
    "#{start_time.try(:strftime, '%H:%M')}〜#{end_time.try(:strftime, '%H:%M')}"
  end
end
