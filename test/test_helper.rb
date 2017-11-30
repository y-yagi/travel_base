module Warning
  def warn(str)
    return if str.match?("gems")
    return if str.match?("warning: possibly useless use of a variable in void context")

    super
  end
end

$VERBOSE = true

require 'coveralls'
require 'support//wait_for_ajax'

Coveralls.wear!('rails')

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'capybara/rails'
require 'webmock/minitest'

WebMock.disable_net_connect!(allow_localhost: true)

Geocoder.configure(lookup: :test)
Geocoder::Lookup::Test.add_stub(
  'tokyo', [
    {'formatted_address': 'tokyo minatoku', 'name' => 'tokyo',
     geometry: { 'location' => { 'lat' => 35.681382, 'lng' => 139.766084, 'address' => 'tokyo' } }
    }
  ]
)
Geocoder::Lookup::Test.add_stub(
  ['35.655048', '132.589155'], [
    { 'formatted_address': '日本 愛媛県伊予市双海町大久保', 'name' => '下灘駅',
      geometry: { 'location': { 'lat': 35.655048, 'lng': 132.589155, 'address': '愛媛' } }
    }
  ]
)

OmniAuth.config.test_mode = true
OmniAuth.config.add_mock(:google_oauth2,
  'uid' => '1',
  'provider' => 'google_oauth2',
)
OmniAuth.config.add_mock(:facebook,
  'uid' => '2',
  'provider' => 'facebook',
)

Minitest::Sound.success = '/home/yaginuma/Dropbox/tmp/music/other/sey.mp3'
Minitest::Sound.failure = '/home/yaginuma/Dropbox/tmp/music/other/mdai.mp3'
Minitest::Sound.during_test = '/home/yaginuma/Dropbox/tmp/music/other/rs1_25_beatthemup.mp3'

Minitest::SlowTest.exclude_test_name = %(test_can_search_places_that_login_user_created)

Minitest::TestProfile.use!

class ActiveSupport::TestCase
  set_fixture_class oauth_applications: Doorkeeper::Application
  fixtures :all
end

class ActionDispatch::IntegrationTest
  fixtures :all
  include Capybara::DSL
  include WaitForAjax

  Capybara.javascript_driver = :selenium_chrome_headless

  def login
    visit '/auth/google_oauth2'
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'test/vcr_cassettes'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
end

Capybara.server = :puma

ScreenshotOpener.command = ""  if ENV["CI"]
