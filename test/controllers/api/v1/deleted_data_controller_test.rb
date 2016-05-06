require 'test_helper'
require 'support/api_helper'

class Api::V1::DeletedDataControllerTest < ActionDispatch::IntegrationTest
  include ApiHelper

  setup do
    @user = users(:google)
    @access_token = get_access_token
    @authorization = 'Bearer ' + @access_token.token
  end

  test 'can get my deleted data list' do
    place = Place.first.destroy!
    travel = Travel.first.destroy!
    get api_v1_deleted_data_path(format: :json), params: { user_id: @user.email, user_provider: @user.provider },
      headers: { 'HTTP_AUTHORIZATION' => @authorization }

    assert_response :success
    assert_equal users(:google).deleted_data.size, response.parsed_body.size
    assert_equal 'places', response.parsed_body[0]['table_name']
    assert_equal place.id, response.parsed_body[0]['datum_id']
    assert_equal 'travels', response.parsed_body[1]['table_name']
    assert_equal travel.id, response.parsed_body[1]['datum_id']
  end

  test 'specify the update date, the data after the date that update can be get' do
    Travel.first.destroy!
    place = Place.first
    travel_to 1.day.since do
      place.destroy!
    end

    get api_v1_deleted_data_path(format: :json),
      params: { user_id: @user.email, user_provider: @user.provider, updated_at: Time.current + 1 },
      headers: { 'HTTP_AUTHORIZATION' => @authorization }
    assert_response :success
    assert_equal 'places', response.parsed_body[0]['table_name']
    assert_equal place.id, response.parsed_body[0]['datum_id']
  end
end
