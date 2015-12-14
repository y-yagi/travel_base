require 'test_helper'
require 'support/api_helper'

class Api::V1::PlacesControllerTest < ActionController::TestCase
  include ApiHelper

  setup do
    @user = users(:google)
    @access_token = get_access_token
    header = 'Bearer ' + @access_token.token
    @request.env['HTTP_AUTHORIZATION'] = header
  end

  test 'can get my places list' do
    get :index, format: :json, user_id: @user.email, user_provider: @user.provider

    assert_response :success
    parsed_response_body = JSON.parse(@response.body)
    assert_equal Place.mine(users(:google)).size, parsed_response_body.size
  end

  test 'specify the update date, the data after the date that update can be get' do
    latest_place = Place.mine(users(:google)).not_gone.first
    travel_to 1.day.since do
      latest_place.update!(name: latest_place.name + ' 更新')
    end

    get :index, format: :json, user_id: @user.email, user_provider: @user.provider, updated_at: Time.current
    assert_response :success
    parsed_response_body = JSON.parse(@response.body)
    assert_equal 1, parsed_response_body.size
    assert_equal latest_place.id, parsed_response_body.first['id']
  end
end
