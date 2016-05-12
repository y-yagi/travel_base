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
  test 'should have the necessary required validators' do
    travel_photo = TravelPhoto.new
    assert_not travel_photo.valid?
    assert_equal [:travel, :photo_service_user_info, :name, :travel_id, :photo_service_album_id], travel_photo.errors.keys
  end
end
