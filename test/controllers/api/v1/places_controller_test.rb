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
end
