require 'test_helper'

class PrivacyControllerTest < ActionController::TestCase
  test 'privacy page' do
    get :index
    assert_response :success
  end
end
