# == Schema Information
#
# Table name: travel_photos
#
#  id                         :integer          not null, primary key
#  name                       :string           not null
#  travel_id                  :integer
#  photo_service_user_info_id :integer
#  photo_service_album_id     :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

require 'test_helper'

class TravelPhotoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
