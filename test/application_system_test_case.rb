require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include WaitForAjax
  driven_by :rack_test

  def login
    visit '/auth/google_oauth2'
  end
end
