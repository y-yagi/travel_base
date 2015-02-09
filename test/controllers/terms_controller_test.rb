require 'test_helper'

class TermsControllerTest < ActionController::TestCase
  test 'term page' do
    get :index
    assert_response :success
  end
end
