require 'test_helper'

class TermsControllerTest < ActionController::TestCase
  test 'term page' do
    get :index
    assert_response :success
    assert_match '利用規約', @response.body
  end
end
