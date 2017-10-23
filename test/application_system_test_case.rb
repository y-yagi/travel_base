require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include WaitForAjax
  driven_by :selenium_chrome_headless

  def login
    visit '/auth/google_oauth2'
  end
end
