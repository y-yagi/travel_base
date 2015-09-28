require 'test_helper'

class UserIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    login
    first(:link, 'ユーザ設定').click
  end

  test 'setup user info' do
    current_user = users(:google)
    assert_not current_user.auto_archive

    within ('#form') do
      check 'user[auto_archive]'
      click_button '更新'
    end
    current_user.reload

    assert current_user.auto_archive
  end

  test 'setup photo serice info' do
    within ('#photo-service') do
      select 'picasa', from: 'user_photo_service_user_info_attributes_service_type'
      fill_in 'user_photo_service_user_info_attributes_photo_service_user_id',
        with: 'photo_serivce@example.com'
      click_button '更新'
    end

    current_user = users(:google)
    assert_equal 'photo_serivce@example.com',
      current_user.photo_service_user_info.photo_service_user_id
    assert current_user.photo_service_user_info.picasa?
  end

  test 'destroy user' do
    destory_user = users(:google)

    before_users_count = User.count
    before_places_count = Place.count
    before_travels_count = Travel.count
    destory_places_count = destory_user.places.size
    destory_traves_count = destory_user.travels.size

    click_link '削除'

    assert_raise(ActiveRecord::RecordNotFound) do
      User.find(destory_user.id)
    end
    assert_equal before_users_count, User.count + 1
    assert_equal before_places_count, Place.count + destory_places_count
    assert_equal before_travels_count, Travel.count + destory_traves_count
  end
end
