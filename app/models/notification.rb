class Notification
  def send
    schedules.each do |schedule|
      HTTP.auth("key=#{ENV['FIREBASE_KEY']}")
        .headers(accept: 'application/json')
        .post('https://fcm.googleapis.com/fcm/send',
          json: {
            'notification': {'body': build_body(schedule)},
            'to': schedule.place.user.raw_device_token
          }
      )
    end
  end

  def build_body(schedule)
    "#{schedule.start_time.try(:strftime, '%H:%M')}〜 #{schedule.place.name}"
  end

  def schedules
    Schedule.includes(:travel_date, place: :user).start_time_in(Time.current, 15.minutes.since)
      .where('users.notification': true)
      .where('travel_dates.date': Date.current)
  end
end
