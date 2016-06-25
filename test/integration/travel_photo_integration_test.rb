require 'test_helper'

class TravelPhotoIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    @travel = travels(:kyoto)
    login
  end

  def test_create_travel_photo
    VCR.insert_cassette('travel_photo_album_list')

    visit new_travel_photo_path(travel_id: @travel.id)

    assert_match '写真データ紐付け', page.text
    assert_match '20160403_sakura', page.text

    select '20160403_sakura', from: 'travel_photo_photo_service_album_id'
    fill_in 'travel_photo_name', with: 'さくらだよ'
    assert_difference 'TravelPhoto.count' do
      click_button '登録'
    end

    travel_photo = TravelPhoto.last
    assert_equal 'さくらだよ', travel_photo.name
    assert_equal '6269279566623512689', travel_photo.photo_service_album_id
    assert_equal @travel.id, travel_photo.travel_id
  ensure
    VCR.eject_cassette
  end
end
