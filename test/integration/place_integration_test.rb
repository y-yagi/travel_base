require 'test_helper'

class PlaceIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    login
    visit places_path
  end

  test 'display places that I registered in list' do
    assert_match '大麻比古神社', page.text
    assert_match '伏見稲荷大社', page.text
    assert_no_match '上賀茂神社', page.text
  end

  test 'create place that search by name' do
    find('.fa-plus-circle').click
    fill_in 'search', with: 'tokyo'
    click_button '検索'

    assert_difference 'Place.count' do
      click_button 'この場所を登録する'
    end
    assert_equal '東京駅', Place.last.name
  end

  test 'create place that regist by form' do
    find('.fa-plus-circle').click

    click_link '名称・住所を登録する'
    fill_in 'place_name', with: '上野駅'
    fill_in 'place_address', with: 'tokyo'
    fill_in 'place_urls_0', with: 'http://www.jreast.co.jp/estation/stations/204.html'
    fill_in 'place_memo', with: 'これは上野駅'

    assert_difference 'Place.count' do
      click_button '登録'
    end
    assert_equal '上野駅', Place.last.name
    assert_equal 'tokyo', Place.last.address
    assert_equal 'http://www.jreast.co.jp/estation/stations/204.html',
      Place.last.urls.first
    assert_equal 'これは上野駅', Place.last.memo
  end

  test 'edit place' do
    place = Place.order('updated_at DESC').first
    first('.fa-edit').click

    fill_in 'place_name', with: '更新名称'
    fill_in 'place_address', with: '更新住所'
    fill_in 'place_urls_0', with: 'http://www.jreast.co.jp/estation/stations/204.html'
    fill_in 'place_memo', with: '更新メモ'
    click_button '登録'
  end

end
