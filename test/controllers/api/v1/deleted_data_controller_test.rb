require 'test_helper'
require 'support/api_helper'

class Api::V1::DeletedDataControllerTest < ActionController::TestCase
  include ApiHelper

  setup do
    @user = users(:google)
    @access_token = get_access_token
    header = 'Bearer ' + @access_token.token
    @request.env['HTTP_AUTHORIZATION'] = header
  end

  test 'can get my deleted data list' do
    place = Place.first.destroy!
    travel = Travel.first.destroy!
    get :index, format: :json, params: { user_id: @user.email, user_provider: @user.provider }

    assert_response :success
    parsed_response_body = JSON.parse(@response.body)
    assert_equal DeletedDatum.mine(users(:google)).size, parsed_response_body.size
    assert_equal 'places', parsed_response_body[0]['table_name']
    assert_equal place.id, parsed_response_body[0]['datum_id']
    assert_equal 'travels', parsed_response_body[1]['table_name']
    assert_equal travel.id, parsed_response_body[1]['datum_id']
  end

  test 'specify the update date, the data after the date that update can be get' do
    Travel.first.destroy!
    place = Place.first
    travel_to 1.day.since do
      place.destroy!
    end

    get :index, format: :json, params: { user_id: @user.email, user_provider: @user.provider, updated_at: Time.current }
    assert_response :success
    parsed_response_body = JSON.parse(@response.body)
    assert_equal 'places', parsed_response_body[0]['table_name']
    assert_equal place.id, parsed_response_body[0]['datum_id']
  end
end
