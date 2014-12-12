# == Schema Information
#
# Table name: travel_dates
#
#  id         :integer          not null, primary key
#  date       :date             not null
#  travel_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class TravelDateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
