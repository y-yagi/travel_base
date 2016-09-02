require 'test_helper'
require 'support/api_helper'

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  include ApiHelper

  setup do
    @user = users(:google)
    @access_token = get_access_token
    @authorization = 'Bearer ' + @access_token.token
  end

  test 'can update token' do
    assert_nil @user.device_token
    patch api_v1_user_registrate_token_path,  params: { user_id: @user.email, user_provider: @user.provider, token: 'token' },
      headers: { 'HTTP_AUTHORIZATION': @authorization }, as: :json

    assert_response :success
    assert_equal 'token', @user.reload.raw_device_token
  end

  test 'get user info' do
    place = users(:google).places.first.destroy!
    travel = users(:google).travels.first.destroy!

    get api_v1_user_path(format: :json),  params: { user_id: @user.email, user_provider: @user.provider },
      headers: { 'HTTP_AUTHORIZATION': @authorization }
    assert_response :success
    parsed_body = JSON.parse(@response.body)

    assert_equal Travel.belong(users(:google)).size, parsed_body['travels'].size
    assert_equal users(:google).places.size, parsed_body['places'].size
    assert_equal users(:google).events.size, parsed_body['events'].size
    assert_equal 'places', parsed_body['deleted_data'][0]['table_name']
    assert_equal place.id, parsed_body['deleted_data'][0]['datum_id']
    assert_equal 'travels', parsed_body['deleted_data'][1]['table_name']
    assert_equal travel.id, parsed_body['deleted_data'][1]['datum_id']
  end
end
