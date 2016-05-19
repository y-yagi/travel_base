require 'test_helper'
require 'support/api_helper'

class Api::V1::EventsControllerTest < ActionDispatch::IntegrationTest
  include ApiHelper

  setup do
    @user = users(:google)
    @access_token = get_access_token
    @authorization = 'Bearer ' + @access_token.token
  end

  test 'can get my event list' do
    get api_v1_events_path(format: :json),  params: { user_id: @user.email, user_provider: @user.provider },
      headers: { 'HTTP_AUTHORIZATION': @authorization }

    assert_response :success
    assert_equal users(:google).events.size, response.parsed_body.size
  end

  test 'specify the update date, the data after the date that update can be get' do
    latest_event = users(:google).events.first
    travel_to 1.day.since do
      latest_event.update!(name: latest_event.name + ' 更新')
    end

    get api_v1_events_path(format: :json), params: { user_id: @user.email, user_provider: @user.provider, updated_at: 1.minute.since },
      headers: { 'HTTP_AUTHORIZATION': @authorization }
    assert_response :success
    assert_equal 1, response.parsed_body.size
    assert_equal latest_event.id, response.parsed_body.first['id']
  end
end
