require 'test_helper'
require 'support/api_helper'

class Api::V1::TravelsControllerTest < ActionController::TestCase
  include ApiHelper

  setup do
    @access_token = get_access_token(users(:google).id)
    header = 'Bearer ' + @access_token.token
    @request.env['HTTP_AUTHORIZATION'] = header
  end

  test 'can get my travel list' do
    get :index, format: :json

    assert_response :success
    parsed_response_body = JSON.parse(@response.body)
    assert_equal Travel.belong(users(:google)).size, parsed_response_body.size
  end

  test 'can get my travel detail' do
    travel = travels(:kyoto)
    get :show, id: travel.id, fields: '*', format: :json

    assert_response :success
  end

  test 'travel include schedule detail' do
    travel = travels(:kyoto)
    get :show, id: travel.id, fields: '*', format: :json

    assert_response :success
    parsed_response_body = JSON.parse(@response.body)

    assert_equal travel.name, parsed_response_body['name']
    assert_equal travel.start_date.to_s, parsed_response_body['start_date']
    assert_equal travel.end_date.to_s, parsed_response_body['end_date']
    assert_equal travel.memo, parsed_response_body['memo']

    assert_equal travel.travel_dates.size, parsed_response_body['travel_dates'].size
    assert_equal travel.travel_dates.first.date.to_s,
      parsed_response_body['travel_dates'].first['date']

    assert_equal travel.travel_dates.first.schedules.size,
      parsed_response_body['travel_dates'].first['schedules'].size

    assert_equal travel.travel_dates.first.schedules.second.route.detail,
      parsed_response_body['travel_dates'].first['schedules'].second['route']['detail']

    assert_equal travel.travel_dates.first.schedules.first.place.name,
      parsed_response_body['travel_dates'].first['schedules'].first['place']['name']
  end

  test "can't get other user's travel detail" do
    travel = users(:twitter).travels.first
    assert_raises ActiveRecord::RecordNotFound do
      get :show, id: travel.id, format: :json
    end
  end
end
