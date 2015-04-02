require 'coveralls'
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
    {
      'formatted_address': 'tokyo minatoku',
      geometry: {
        'location' => {
          'lat'     => 35.681382,
          'lng'     => 139.766084,
          'address' => 'tokyo',
        }
      },
      address_components: [
        {
          'long_name' => '東京駅',
        }
      ]
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

class ActiveSupport::TestCase
  fixtures :all
end

class ActionDispatch::IntegrationTest
  fixtures :all
  include Capybara::DSL

  require 'capybara/poltergeist'
  Capybara.javascript_driver = :poltergeist

  def login
    visit '/auth/google_oauth2'
  end
end

