require 'test_helper'
require 'support/api_helper'

class Api::V1::PlacesControllerTest < ActionDispatch::IntegrationTest
  include ApiHelper

  setup do
    @user = users(:google)
    @access_token = get_access_token
    @authorization = 'Bearer ' + @access_token.token
  end

  test 'can get my places list' do
    get api_v1_places_path(format: :json),  params: { user_id: @user.email, user_provider: @user.provider },
      headers: { 'HTTP_AUTHORIZATION': @authorization }

    assert_response :success
    assert_equal users(:google).places.size, response.parsed_body.size
  end

  test 'specify the update date, the data after the date that update can be get' do
    latest_place = users(:google).places.not_gone.first
    travel_to 1.day.since do
      latest_place.update!(name: latest_place.name + ' 更新')
    end

    get api_v1_places_path(format: :json), params: { user_id: @user.email, user_provider: @user.provider, updated_at: 1.minute.since },
      headers: { 'HTTP_AUTHORIZATION': @authorization }
    assert_response :success
    assert_equal 1, response.parsed_body.size
    assert_equal latest_place.id, response.parsed_body.first['id']
  end

  test 'can create place' do
    assert_difference 'Place.count' do
      post api_v1_places_path(format: :json), params: { user_id: @user.email, user_provider: @user.provider,
        name: '赤羽駅', address: '東京都北区赤羽一丁目1-1', latitude: 35.46409, longitude: 139.4315 },
        headers: { 'HTTP_AUTHORIZATION': @authorization }
    end

    assert_response :success

    place = Place.last
    assert_equal '赤羽駅', place.name
    assert_equal '東京都北区赤羽一丁目1-1', place.address
    assert_equal 35.46409, place.latitude
    assert_equal 139.4315, place.longitude
  end

  test 'can not create a place in the user that is not authenticated' do
    assert_no_difference 'Place.count' do
      post api_v1_places_path(format: :json), params: { user_id: @user.email, user_provider: @user.provider,
        name: '赤羽駅', address: '東京都北区赤羽一丁目1-1', latitude: 35.46409, longitude: 139.4315 }
    end

    assert_response 401
  end

  test "supplemented with automatic if the address is not" do
    post api_v1_places_path(format: :json), params: { user_id: @user.email, user_provider: @user.provider,
      name: '下灘駅', latitude: 35.655048, longitude: 132.589155 },
      headers: { 'HTTP_AUTHORIZATION': @authorization }

    assert_response :success

    place = Place.last
    assert_equal '下灘駅', place.name
    assert_equal '愛媛県伊予市双海町大久保', place.address
    assert_equal 35.655048, place.latitude
    assert_equal 132.589155, place.longitude
  end
end
