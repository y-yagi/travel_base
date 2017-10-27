require 'application_system_test_case'

class EventsTest < ApplicationSystemTestCase
  setup do
    login
    visit events_path
  end

  test 'display events that I registered in list' do
    assert_match '大麻比古神社例祭', page.text
    assert_no_match '賀茂祭', page.text
  end

  test 'create event' do
    find('.fa-plus-circle').click

    fill_in 'event_name', with: '稲荷祭'
    select '伏見稲荷大社', from: 'event_place_id'
    fill_in 'event_detail', with: 'この祭りの起源は極めて古く、諸説ある中に、すでに長久元年（1040）に行われた事が「春記」にみえ、「中右記」をはじめ諸記録によっても平安中期には盛んに行われていたことが知られます。'
    fill_in 'event_start_date', with: '2016-05-03'
    fill_in 'event_end_date', with: '2016-05-04'
    fill_in 'event_url', with: 'http://inari.jp/about/num06/'

    assert_difference 'Event.count' do
      click_button '登録'
    end

    event = Event.last
    assert_equal '稲荷祭', event.name
    assert_equal '伏見稲荷大社', event.place.name
    assert_equal 'この祭りの起源は極めて古く、諸説ある中に、すでに長久元年（1040）に行われた事が「春記」にみえ、「中右記」をはじめ諸記録によっても平安中期には盛んに行われていたことが知られます。', event.detail
    assert_equal Date.parse('2016-05-03'), event.start_date
    assert_equal Date.parse('2016-05-04'), event.end_date
    assert_equal 'http://inari.jp/about/num06/', event.url
  end

  test 'show event' do
    event = events(:ooasahiko)
    visit event_path(event)

    assert_match event.name, page.text
    assert_match event.detail, page.text
    assert_match I18n.l(event.start_date, format: :long), page.text
    assert_match I18n.l(event.end_date, format: :long), page.text
    assert_match event.place.name, page.text
    assert_match event.place.address, page.text
    assert_match 'http://www.ooasahikojinja.jp/maturi/', page.text
  end

  test 'edit event' do
    event = events(:ooasahiko)
    first("a[title='編集']").click
    fill_in 'event_name', with: '稲荷祭2'
    select '伏見稲荷大社', from: 'event_place_id'
    fill_in 'event_detail', with: '更新したざます'
    fill_in 'event_start_date', with: '2017-05-03'
    fill_in 'event_end_date', with: '2017-05-04'
    fill_in 'event_url', with: 'https://www.google.co.jp'

    click_button '登録'
    event.reload

    assert_equal '稲荷祭2', event.name
    assert_equal '伏見稲荷大社', event.place.name
    assert_equal '更新したざます', event.detail
    assert_equal Date.parse('2017-05-03'), event.start_date
    assert_equal Date.parse('2017-05-04'), event.end_date
    assert_equal 'https://www.google.co.jp', event.url
  end

  test 'destroy event' do
    first("a[title='削除']").click

    visit events_path
    assert_no_match '大麻比古神社例祭', page.text
    assert_no_match '賀茂祭', page.text
  end
end
