require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
  setup do
    login
    first(:link, 'ユーザ設定').click
  end

  test 'setup user info' do
    current_user = users(:google)
    current_user.update!(admin: true)
    visit current_path

    assert_not current_user.auto_archive

    within ('#form') do
      check 'user[auto_archive]'
      check 'user[notification]'
      click_button '更新'
    end
    current_user.reload

    assert current_user.auto_archive
    assert current_user.notification
  end

  test 'destroy user' do
    destroy_user = users(:google)

    before_users_count = User.count
    before_places_count = Place.count
    before_travels_count = Travel.count
    destroy_places_count = destroy_user.places.size
    destroy_traves_count = destroy_user.travels.size

    click_link '削除'

    assert_raise(ActiveRecord::RecordNotFound) do
      User.find(destroy_user.id)
    end
    assert_equal before_users_count, User.count + 1
    assert_equal before_places_count, Place.count + destroy_places_count
    assert_equal before_travels_count, Travel.count + destroy_traves_count
  end
end
