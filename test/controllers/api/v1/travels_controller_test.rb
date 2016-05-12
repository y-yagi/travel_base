require 'test_helper'
require 'support/api_helper'

class Api::V1::TravelsControllerTest < ActionDispatch::IntegrationTest
  include ApiHelper

  setup do
    @user = users(:google)
    @access_token = get_access_token
    @authorization = 'Bearer ' + @access_token.token
  end

  test 'can get my travel list' do
    get api_v1_travels_path(format: :json), params: { user_id: @user.email, user_provider: @user.provider },
      headers: { 'HTTP_AUTHORIZATION': @authorization }

    assert_response :success
    assert_equal Travel.belong(users(:google)).size, response.parsed_body.size
  end

  test 'can get my travel detail' do
    travel = travels(:kyoto)
    get api_v1_travel_path(travel.id, format: :json), params: { user_id: @user.email, user_provider: @user.provider, fields: '*' },
      headers: { 'HTTP_AUTHORIZATION': @authorization }

    assert_response :success
  end

  test "can't get other user's travel detail" do
    travel = users(:twitter).travels.first
    assert_raises ActiveRecord::RecordNotFound do
      get api_v1_travel_path(travel.id, format: :json), params: { user_id: @user.email, user_provider: @user.provider },
        headers: { 'HTTP_AUTHORIZATION': @authorization }
    end
  end

  test 'json include travel data' do
    travel = travels(:kyoto)
    get api_v1_travel_path(travel.id, format: :json), params: { user_id: @user.email, user_provider: @user.provider, fields: '*' },
      headers: { 'HTTP_AUTHORIZATION': @authorization }

    assert_equal travel.name, response.parsed_body['name']
    assert_equal travel.start_date.to_s, response.parsed_body['start_date']
    assert_equal travel.end_date.to_s, response.parsed_body['end_date']
    assert_equal travel.memo, response.parsed_body['memo']
    assert_equal I18n.l(travel.start_date, format: :long), response.parsed_body['formatted_start_date']
    assert_equal I18n.l(travel.end_date, format: :long), response.parsed_body['formatted_end_date']
    assert_equal travel.updated_at.as_json, response.parsed_body['updated_at']
  end

  test 'json include travel date date' do
    travel = travels(:kyoto)
    get api_v1_travel_path(travel.id, format: :json), params: { user_id: @user.email, user_provider: @user.provider, fields: '*' },
      headers: { 'HTTP_AUTHORIZATION': @authorization }

    assert_equal travel.travel_dates.size, response.parsed_body['travel_dates'].size
    assert_equal travel.travel_dates.first.date.to_s,
      response.parsed_body['travel_dates'].first['date']
  end

  test 'json include schedules data' do
    travel = travels(:kyoto)
    get api_v1_travel_path(travel.id, format: :json), params: { user_id: @user.email, user_provider: @user.provider, fields: '*' },
      headers: { 'HTTP_AUTHORIZATION': @authorization }

    assert_equal travel.travel_dates.first.schedules.size,
      response.parsed_body['travel_dates'].first['schedules'].size
    assert_equal travel.travel_dates.first.schedules.first.id,
      response.parsed_body['travel_dates'].first['schedules'].first['id']
    assert_equal travel.travel_dates.first.schedules.first.memo,
      response.parsed_body['travel_dates'].first['schedules'].first['memo']
    assert_equal travel.travel_dates.first.schedules.first.start_time.strftime("%H:%M"),
      response.parsed_body['travel_dates'].first['schedules'].first['formatted_start_time']
    assert_equal travel.travel_dates.first.schedules.first.end_time.strftime("%H:%M"),
      response.parsed_body['travel_dates'].first['schedules'].first['formatted_end_time']
  end

  test 'json include route data' do
    travel = travels(:kyoto)
    get api_v1_travel_path(travel.id, format: :json), params: { user_id: @user.email, user_provider: @user.provider, fields: '*' },
      headers: { 'HTTP_AUTHORIZATION': @authorization }

    assert_equal travel.travel_dates.first.schedules.second.route.detail,
      response.parsed_body['travel_dates'].first['schedules'].second['route']['detail']
  end

  test 'json include place data' do
    travel = travels(:kyoto)
    get api_v1_travel_path(travel.id, format: :json), params: { user_id: @user.email, user_provider: @user.provider, fields: '*' },
      headers: { 'HTTP_AUTHORIZATION': @authorization }

    expected_place = travel.travel_dates.first.schedules.first.place
    actual_place = response.parsed_body['travel_dates'].first['schedules'].first['place']
    assert_equal expected_place.name, actual_place['name']
    assert_equal expected_place.address, actual_place['address']
    assert_equal expected_place.urls.join(','), actual_place['url']
    assert_match expected_place.places_station.first.station.name, actual_place['station_info']
    assert_match expected_place.status, actual_place['status']
  end

  test 'json include dropbox file data' do
    travel = travels(:kyoto)
    get api_v1_travel_path(travel.id, format: :json), params: { user_id: @user.email, user_provider: @user.provider, fields: '*' },
      headers: { 'HTTP_AUTHORIZATION': @authorization }

    assert_equal travel.dropbox_files.size, response.parsed_body['dropbox_files'].size
    assert_equal travel.dropbox_files.first.name, response.parsed_body['dropbox_files'].first['name']
    assert_equal travel.dropbox_files.first.url, response.parsed_body['dropbox_files'].first['url']
  end

  test 'specify the update date, the data after the date that update can be get' do
    latest_travel = Travel.mine(users(:google)).order(:updated_at).last
    travel_to 1.day.since do
      latest_travel.update!(name: latest_travel.name + ' 更新')
    end

    get api_v1_travels_path(format: :json), params: { user_id: @user.email, user_provider: @user.provider, updated_at: 1.minute.since },
      headers: { 'HTTP_AUTHORIZATION': @authorization }
    assert_response :success
    assert_equal 1, response.parsed_body.size
    assert_equal latest_travel.id, response.parsed_body.first['id']
  end
end
