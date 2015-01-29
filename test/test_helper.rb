require 'coveralls'
Coveralls.wear!('rails')

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'capybara/rails'

class ActiveSupport::TestCase
  fixtures :all

  def assert_valid(record, message = nil)
    message ||= "Expected #{record.inspect} to be valid"
    assert record.valid?, message
  end

  def assert_invalid(record, options = {})
    assert record.invalid?, "Expected #{record.inspect} to be invalid"
    options.each do |attribute, message|
      assert_includes record.errors[attribute], message
    end
  end
end

class ActionDispatch::IntegrationTest
  fixtures :all
  include Capybara::DSL

  require 'capybara/poltergeist'
  Capybara.javascript_driver = :poltergeist
end

Geocoder.configure(lookup: :test)
Geocoder::Lookup::Test.add_stub(
  'tokyo', [
    {
      geometry: {
        'location' => {
          'lat'     => 35.681382,
          'lng'     => 139.766084,
          'address' => 'tokyo',
        }
      }
    }
  ]
)

Minitest::Sound.success = '/home/yaginuma/Dropbox/tmp/music/other/sey.mp3'
Minitest::Sound.failure = '/home/yaginuma/Dropbox/tmp/music/other/mdai.mp3'
Minitest::Sound.during_test = '/home/yaginuma/Dropbox/tmp/music/other/rs1_25_beatthemup.mp3'
