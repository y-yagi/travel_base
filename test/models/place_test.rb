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
    assert_equal [:user, :name, :address, :user_id], place.errors.keys
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
    assert_equal place.errors.keys, [:user, :latitude, :longitude]
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

  test 'deleted data is recorded' do
    place = Place.first
    place.destroy!

    deleted_datum = DeletedDatum.last

    assert_equal 'places', deleted_datum.table_name
    assert_equal place.id, deleted_datum.datum_id
    assert_equal place.user_id, deleted_datum.user_id
  end

  test '#prefecture' do
    assert_equal '北海道', Place.new(address: '北海道札幌市中央区北1条西5丁目4番地').prefecture
    assert_equal '東京都', Place.new(address: '東京都港区芝公園４丁目２−８').prefecture
    assert_equal '京都府', Place.new(address: '京都府京都市伏見区深草藪之内町６８').prefecture
    assert_empty Place.new(address: 'とどうふけん無し').prefecture
  end
end
