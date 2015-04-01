require 'test_helper'
require 'support/heart_rails_api_helper'

class PlaceTest < ActiveSupport::TestCase
  include HeartRailsExpressApiHelper

  test 'should have the necessary required validators' do
    place = Place.new
    assert_not place.valid?
    assert_equal [:name, :address, :user_id], place.errors.keys
  end

  test 'validate error when set 256 character in name' do
    place = Place.new(name: 'a' * 256)
    assert_not place.valid?
    assert_includes place.errors.keys, :name
  end

  test 'can set 255 character in name' do
    place = Place.new(name: 'a' * 255)
    assert_not place.valid?
    assert_not_includes place.errors.keys, :name
  end

  test 'validate error when address is not nil' do
    place = Place.new(address: 'tokyo', name: 'tokyo', user_id: 1)
    assert_not place.valid?
    assert_equal place.errors.keys, [:latitude, :longitude]
  end

  test 'build method return Place instance' do
    params = ActionController::Parameters.new(name: 'tokyo', latitude: '10.1000')
    params.permit!
    place = Place.build(params, users(:google))
    assert_instance_of Place, place
    assert_equal place.user_id, users(:google).id
  end

  test 'set latitude and longitude to place object' do
    place = Place.new(address: 'tokyo', name: 'tokyo', user_id: 1)
    place.set_geoinfo!

    assert_equal 35.681382, place.latitude
    assert_equal 139.766084, place.longitude
  end

  test 'set station info' do
    place = places(:kifune)
    set_station_mock

    assert_difference('PlacesStation.count', 2) do
      place.set_station_info
    end

    assert_equal '310m', place.places_station.first.distance
    assert_equal 134.997666, place.places_station.first.station.longitude
    assert_equal 35.002054, place.places_station.first.station.latitude
    assert_equal 'JR加古川線', place.places_station.first.station.line
    assert_equal '日本へそ公園', place.places_station.first.station.name
  end
end
