require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  test '#build_body' do
    notification = Notification.new
    assert_equal '13:00〜 貴船神社', notification.build_body(schedules(:kifune))
  end

  test '#schedules' do
    notification = Notification.new
    assert_empty notification.schedules

    kifune = schedules(:kifune)
    kifune.travel_date.update!(date: Date.current)
    kifune.place.user.update!(notification: true)
    kifune.update!(start_time: 10.minutes.since + 9.hours)
    assert_equal [kifune], notification.schedules

    kifune.update!(start_time: 20.minutes.since + 9.hours)
    assert_empty notification.schedules
  end
end
