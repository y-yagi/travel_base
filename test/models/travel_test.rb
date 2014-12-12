# == Schema Information
#
# Table name: travels
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  memo       :text
#  start_date :date
#  end_date   :date
#  deleted_at :datetime
#  owner_id   :integer          not null
#  members    :integer          is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class TravelTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
