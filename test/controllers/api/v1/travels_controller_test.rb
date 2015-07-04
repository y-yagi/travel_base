require 'test_helper'
require 'support/api_helper'

class Api::V1::TravelsControllerTest < ActionController::TestCase
  include ApiHelper

  setup do
    @user = users(:google)
    @access_token = get_access_token
    header = 'Bearer ' + @access_token.token
    @request.env['HTTP_AUTHORIZATION'] = header
  end

  test 'can get my travel list' do
    get :index, format: :json, user_id: @user.email, user_provider: @user.provider

    assert_response :success
    parsed_response_body = JSON.parse(@response.body)
    assert_equal Travel.belong(users(:google)).size, parsed_response_body.size
  end

  test 'can get my travel detail' do
    travel = travels(:kyoto)
    get :show, id: travel.id, fields: '*',
      format: :json, user_id: @user.email, user_provider: @user.provider

    assert_response :success
  end

  test "can't get other user's travel detail" do
    travel = users(:twitter).travels.first
    assert_raises ActiveRecord::RecordNotFound do
      get :show, id: travel.id, format: :json,
        user_id: @user.email, user_provider: @user.provider
    end
  end

  test 'json include travel data' do
    travel = travels(:kyoto)
    get :show, id: travel.id, fields: '*',
      format: :json, user_id: @user.email, user_provider: @user.provider
    parsed_response_body = JSON.parse(@response.body)

    assert_equal travel.name, parsed_response_body['name']
    assert_equal travel.start_date.to_s, parsed_response_body['start_date']
    assert_equal travel.end_date.to_s, parsed_response_body['end_date']
    assert_equal travel.memo, parsed_response_body['memo']
    assert_equal I18n.l(travel.start_date, format: :long), parsed_response_body['formatted_start_date']
    assert_equal I18n.l(travel.end_date, format: :long), parsed_response_body['formatted_end_date']
    assert_equal travel.updated_at.as_json, parsed_response_body['updated_at']
  end

  test 'json include travel date date' do
    travel = travels(:kyoto)
    get :show, id: travel.id, fields: '*',
      format: :json, user_id: @user.email, user_provider: @user.provider
    parsed_response_body = JSON.parse(@response.body)

    assert_equal travel.travel_dates.size, parsed_response_body['travel_dates'].size
    assert_equal travel.travel_dates.first.date.to_s,
      parsed_response_body['travel_dates'].first['date']
  end

  test 'json include schedules data' do
    travel = travels(:kyoto)
    get :show, id: travel.id, fields: '*',
      format: :json, user_id: @user.email, user_provider: @user.provider
    parsed_response_body = JSON.parse(@response.body)

    assert_equal travel.travel_dates.first.schedules.size,
      parsed_response_body['travel_dates'].first['schedules'].size
    assert_equal travel.travel_dates.first.schedules.first.id,
      parsed_response_body['travel_dates'].first['schedules'].first['id']
    assert_equal travel.travel_dates.first.schedules.first.memo,
      parsed_response_body['travel_dates'].first['schedules'].first['memo']
    assert_equal travel.travel_dates.first.schedules.first.start_time.strftime("%H:%M"),
      parsed_response_body['travel_dates'].first['schedules'].first['formatted_start_time']
    assert_equal travel.travel_dates.first.schedules.first.end_time.strftime("%H:%M"),
      parsed_response_body['travel_dates'].first['schedules'].first['formatted_end_time']
  end

  test 'json include route data' do
    travel = travels(:kyoto)
    get :show, id: travel.id, fields: '*',
      format: :json, user_id: @user.email, user_provider: @user.provider
    parsed_response_body = JSON.parse(@response.body)

    assert_equal travel.travel_dates.first.schedules.second.route.detail,
      parsed_response_body['travel_dates'].first['schedules'].second['route']['detail']
  end

  test 'json include place data' do
    travel = travels(:kyoto)
    get :show, id: travel.id, fields: '*',
      format: :json, user_id: @user.email, user_provider: @user.provider
    parsed_response_body = JSON.parse(@response.body)

    expected_place = travel.travel_dates.first.schedules.first.place
    actual_place = parsed_response_body['travel_dates'].first['schedules'].first['place']
    assert_equal expected_place.name, actual_place['name']
    assert_equal expected_place.address, actual_place['address']
    assert_equal expected_place.urls.join(','), actual_place['url']
    assert_match expected_place.places_station.first.station.name, actual_place['station_info']
  end
end
