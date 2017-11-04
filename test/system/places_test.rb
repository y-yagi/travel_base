require 'application_system_test_case'

class PlacesTest < ApplicationSystemTestCase
  setup do
    login
    visit places_path
  end

  test 'display places that I registered in list' do
    assert_match '大麻比古神社', page.text
    assert_match '伏見稲荷大社', page.text
    assert_no_match '上賀茂神社', page.text
  end

  test 'display places that filtered by tag' do
    visit places_path(tag: '京都')
    assert_match '伏見稲荷大社', page.text
    assert_no_match '大麻比古神社', page.text
  end

  test 'create place that search by name' do
    find('.fa-plus-circle').click
    fill_in 'place_search', with: 'tokyo'
    click_button '検索'

    assert_difference 'Place.count' do
      click_button 'この場所を登録する'
    end
    assert_equal 'tokyo', Place.last.name
  end

  test 'create place that regist by form' do
    find('.fa-plus-circle').click

    click_link '名称・住所を登録する'
    fill_in 'place_name', with: '上野駅'
    fill_in 'place_address', with: 'tokyo'
    fill_in 'place_tags', with: '駅,東京'
    fill_in 'place_urls_0', with: 'http://www.jreast.co.jp/estation/stations/204.html'
    fill_in 'place_memo', with: 'これは上野駅'

    assert_difference 'Place.count' do
      click_button '登録'
    end
    assert_equal '上野駅', Place.last.name
    assert_equal 'tokyo', Place.last.address
    assert_equal %w(駅 東京), Place.last.tags
    assert_equal 'http://www.jreast.co.jp/estation/stations/204.html',
      Place.last.urls.first
    assert_equal 'これは上野駅', Place.last.memo
  end

  test 'show place' do
    place = places(:fushimiinari)
    visit place_path(place)

    assert_match place.name, page.text
    assert_match place.address, page.text
    assert_match place.places_station.first.station.name, page.text
    assert_match place.places_station.first.station.line, page.text
    assert_match place.places_station.first.distance, page.text
    place.tags.each { |t| assert_match t, page.text }
  end

  test 'edit place' do
    place = Place.order('updated_at DESC').first
    first("a[title='編集']").click

    fill_in 'place_name', with: '更新名称'
    fill_in 'place_address', with: '更新住所'
    fill_in 'place_tags', with: '更新タグ'
    fill_in 'place_urls_0', with: 'http://www.jreast.co.jp/estation/stations/200.html'
    fill_in 'place_memo', with: '更新メモ'
    click_button '登録'
    place.reload

    assert_equal '更新名称', place.name
    assert_equal '更新住所', place.address
    assert_equal %w(更新タグ), place.tags
    assert_equal 'http://www.jreast.co.jp/estation/stations/200.html', place.urls.first
    assert_equal '更新メモ', place.memo
  end

  test 'destroy place' do
    first("a[title='削除']").click

    visit places_path
    assert_no_match '大麻比古神社', page.text
    assert_match '伏見稲荷大社', page.text
    assert_no_match '上賀茂神社', page.text
  end

  test 'archive place' do
    first("a[title='アーカイブ']").click

    visit places_path
    assert_no_match '大麻比古神社', page.text
    assert_match '伏見稲荷大社', page.text
    assert_no_match '上賀茂神社', page.text

    find('.fa-history').click
    assert_match '大麻比古神社', page.text
    assert_no_match '伏見稲荷大社', page.text
  end

  test 'restore archived place' do
    Place.order('updated_at DESC').first.update_attributes!(status: :already_went)
    find('.fa-history').click

    assert_match '大麻比古神社', page.text
    assert_no_match '伏見稲荷大社', page.text

    first("a[title='戻す']").click
    assert_match '大麻比古神社', page.text
    assert_match '伏見稲荷大社', page.text
  end

  test 'paging' do
    assert_no_match 'places_9', page.text
    click_link '最後'

    assert_match 'places_9', page.text
    assert_no_match 'places_0', page.text
  end
end
