require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  test 'should have the necessary required validators' do
    schedule = Schedule.new
    assert_not schedule.valid?
    assert_equal [:travel_date_id, :place_id], schedule.errors.keys
  end

  test '".build" return Schedule instance' do
    params = ActionController::Parameters.new
    params.permit!
    schedule = Schedule.build(params)
    assert_instance_of Schedule, schedule
  end

  test 'should error when register already registered place' do
    new_schedule = schedules(:kifune).dup
    new_schedule.valid?

    assert_equal [:place], new_schedule.errors.keys
  end
end
