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
end
