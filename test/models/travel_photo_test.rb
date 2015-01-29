require 'test_helper'

class TravelPhotoTest < ActiveSupport::TestCase
  test 'should have the necessary required validators' do
    travel_photo = TravelPhoto.new
    assert_not travel_photo.valid?
    assert_equal [:name, :travel_id, :photo_service_album_id], travel_photo.errors.keys
  end
end
