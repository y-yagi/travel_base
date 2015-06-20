require 'test_helper'

class PhotoServiceUserInfoTest < ActiveSupport::TestCase
  test 'photo_service_user_info when you update the travel_photos be deleted' do
    picasa_user_info = photo_service_user_infos(:picasa)

    assert_difference('TravelPhoto.count', -1) do
      picasa_user_info = photo_service_user_infos(:picasa)
      picasa_user_info.destroy
    end
  end
end
