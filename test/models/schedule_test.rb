# == Schema Information
#
# Table name: schedules
#
#  id                 :integer          not null, primary key
#  memo               :text
#  start_time         :time
#  end_time           :time
#  travel_date_id     :integer          not null
#  place_id           :integer          not null
#  route_id           :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  attachment_file_id :string
#

require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  test 'should have the necessary required validators' do
    schedule = Schedule.new
    assert_not schedule.valid?
    assert_equal [:travel_date, :place, :travel_date_id, :place_id], schedule.errors.keys
  end

  test '".build" return Schedule instance' do
    params = ActionController::Parameters.new
    params.permit!
    schedule = Schedule.build(params)
    assert_instance_of Schedule, schedule
  end

  test 'should error when register already registered place' do
    new_schedule = schedules(:kifune).dup

    assert_not new_schedule.valid?
    assert_equal [:place], new_schedule.errors.keys
  end

  test 'should not error when register already registered place to another date' do
    new_schedule = schedules(:kifune).dup
    new_schedule.travel_date = travel_dates(:kyoto_date_2)

    assert new_schedule.valid?
  end
end
