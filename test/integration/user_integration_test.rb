require 'test_helper'

class UserIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    login
    first(:link, '登録情報').click
  end

  test 'setup photo serice info' do
    select 'picasa', from: 'user_photo_service_user_info_attributes_service_type'
    fill_in 'user_photo_service_user_info_attributes_photo_service_user_id',
      with: 'photo_serivce@example.com'
    click_button '更新'

    current_user = users(:google)
    assert_equal 'photo_serivce@example.com',
      current_user.photo_service_user_info.photo_service_user_id
    assert current_user.photo_service_user_info.picasa?
  end
end
