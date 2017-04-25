require 'test_helper'

class PhotoServiceInfoWrapperTest < ActiveSupport::TestCase
  test 'return Picasa::Client instance when use picasa' do
    psui = photo_service_user_infos(:picasa)
    assert_instance_of Picasa::Client, PhotoServiceInfoWrapper.get_client(psui)
  end

  test 'return nil when do not use picasa' do
    psui = photo_service_user_infos(:picasa)
    psui.service_type = nil
    assert_not PhotoServiceInfoWrapper.get_client(psui)
  end
end
