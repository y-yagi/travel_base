# == Schema Information
#
# Table name: schedules
#
#  id             :integer          not null, primary key
#  memo           :text
#  start_time     :datetime         not null
#  end_time       :datetime         not null
#  travel_date_id :integer          not null
#  place_id       :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
