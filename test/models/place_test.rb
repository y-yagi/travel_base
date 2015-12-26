# == Schema Information
#
# Table name: places
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  address    :string           not null
#  memo       :text
#  latitude   :float
#  longitude  :float
#  urls       :string           is an Array
#  user_id    :integer          not null
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tags       :string           is an Array
#

require 'test_helper'

class PlaceTest < ActiveSupport::TestCase
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
    PlacesStation.delete_all
    place = places(:kifune)

    VCR.use_cassette('places_station') do
      assert_difference('PlacesStation.count', 3) do
        place.set_station_info
      end
    end

    assert_equal '4280m', place.places_station.first.distance
    assert_equal 135.483455, place.places_station.first.station.longitude
    assert_equal 35.102168, place.places_station.first.station.latitude
    assert_equal 'JR山陰本線', place.places_station.first.station.line
    assert_equal '園部', place.places_station.first.station.name
  end
end
