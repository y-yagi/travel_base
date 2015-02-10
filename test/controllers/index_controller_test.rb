require 'test_helper'

class IndexControllerTest < ActionController::TestCase
  test 'logout top page' do
    get :index
    assert_response :success
    assert_match 'Welcome to Travel Base', @response.body
  end
end
