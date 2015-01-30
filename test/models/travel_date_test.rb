require 'test_helper'

class TravelDateTest < ActiveSupport::TestCase
  test 'should have the necessary required validators' do
    travel_date = TravelDate.new
    assert_not travel_date.valid?
    assert_equal [:date, :travel_id], travel_date.errors.keys
  end
end
