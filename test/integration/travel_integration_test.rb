require 'test_helper'

class TravelIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    login
    visit travels_path
  end

  test 'display places that I registered in list' do
    assert_match '京都旅行', page.text
    assert_match '岡山旅行', page.text
    assert_no_match '山口旅行', page.text
  end

  test 'create travel' do
    find('.fa-plus-circle').click

    fill_in 'travel_name', with: '富山旅行'
    fill_in 'travel_start_date', with: 90.days.since
    fill_in 'travel_end_date', with: 92.days.since
    fill_in 'travel_memo', with: '年内には行きたい'

    assert_difference 'Travel.count' do
      click_button '登録'
    end
    assert_equal '富山旅行', Travel.last.name
    assert_equal 90.days.since.to_date, Travel.last.start_date
    assert_equal 92.days.since.to_date, Travel.last.end_date
    assert_equal '年内には行きたい', Travel.last.memo
  end

  test 'edit travel' do
    travel = Travel.order('updated_at DESC').first
    first("a[title='編集']").click

    fill_in 'travel_name', with: '更新旅行'
    fill_in 'travel_start_date', with: 3.days.since
    fill_in 'travel_end_date', with: 4.days.since
    fill_in 'travel_memo', with: '更新メモ'

    click_button '登録'
    travel.reload

    assert_equal '更新旅行', travel.name
    assert_equal 3.days.since.to_date, travel.start_date
    assert_equal 4.days.since.to_date, travel.end_date
    assert_equal '更新メモ', travel.memo
  end

  test 'destroy travel' do
    first("a[title='削除']").click

    assert_no_match '京都旅行', page.text
    assert_match '岡山旅行', page.text
    assert_no_match '山口旅行', page.text
  end

  test 'show future travel' do
    travel = travels(:kyoto)
    visit travel_path(travel)

    assert_match travel.memo, page.text
    assert_match '予定を追加する', page.text
    assert_match '貴船神社', page.text
    assert_match '13:00〜15:00', page.text
    assert_match 'ライトアップもある', page.text
    assert_match 'バスで30分', page.text
  end

  test 'show past travel' do
    travel = travels(:okayama)
    visit travel_path(travel)

    assert_match travel.memo, page.text
    assert_match '写真管理', page.text
  end

  test 'add schedule' do
    travel = travels(:kyoto)
    place = places(:fushimiinari)
    travel_date = travel.travel_dates.second
    visit travel_path(travel)

    click_link '予定を追加する'
    select I18n.l(travel_date.date, format: :long),
      from: 'schedule_travel_date_id'
    fill_in 'schedule_start_time', with: '9:15'
    fill_in 'schedule_end_time', with: '10:30'
    select place.name, from: 'schedule_place_id'

    assert_difference 'Schedule.count' do
      click_button '登録'
    end

    assert_equal 9, Schedule.last.start_time.hour
    assert_equal 15, Schedule.last.start_time.min
    assert_equal 10, Schedule.last.end_time.hour
    assert_equal 30, Schedule.last.end_time.min
    assert_equal travel_date.id,
      Schedule.last.travel_date.id
    assert_equal place.id, Schedule.last.place.id

    assert_match '伏見稲荷大社', page.text
    assert_match '09:15〜10:30', page.text
  end

  test 'edit schedule' do
    travel = travels(:kyoto)
    schedule = travel.travel_dates.first.schedules.first
    visit travel_path(travel)
    find("a[href='#{edit_schedule_path(schedule)}']").click

    assert_match schedule.place.name, page.text
    fill_in 'schedule_start_time', with: '12:20'
    fill_in 'schedule_end_time', with: '13:55'
    fill_in 'schedule_memo', with: 'お昼に注意'
    click_button '更新'

    assert_match 'お昼に注意', page.text
    assert_match '12:20〜13:55', page.text
  end

  test 'destroy schedule' do
    travel = travels(:kyoto)
    schedule = schedules(:kifune)
    visit travel_path(travel)
    find("a[href='#{schedule_path(schedule)}']").click

    assert_no_match '13:00〜15:00', page.text
    assert_no_match 'ライトアップもある', page.text
  end

  test 'add route' do
    travel = travels(:kyoto)
    visit travel_path(travel)
    first("a[title='移動方法を登録する']").click
    fill_in 'route_detail', with: '電車で移動します'
    click_button '登録'

    assert_match '電車で移動します', page.text
  end

  test 'edit route' do
    travel = travels(:kyoto)
    route = routes(:route_to_shimogamo)
    visit travel_path(travel)
    find("a[href='#{edit_schedule_route_path(route.schedule, route)}']").click

    fill_in 'route_detail', with: '電車とバスで30分'
    click_button '登録'

    assert_match '電車とバスで30分', page.text
  end

  test 'remove route' do
    travel = travels(:kyoto)
    route = routes(:route_to_shimogamo)
    visit travel_path(travel)
    find("a[href='#{schedule_route_path(route.schedule, route)}']").click

    assert_no_match 'バスで30分', page.text
  end

  test 'paging' do
    assert_no_match 'travels_9', page.text
    click_link '最後'

    assert_match 'travels_9', page.text
    assert_no_match 'travels_0', page.text
  end

  test 'icalendar data' do
    travel = travels(:kyoto)
    visit travel_path(travel, format: :ics)

    assert_match 'DESCRIPTION:宿は未定', page.text
    assert_match 'SUMMARY:京都旅行', page.text
  end

  test 'add members link is displayed' do
    travel = Travel.order('updated_at DESC').first
    first("a[title='編集']").click
    click_link 'メンバー管理'

    invite_url = find('#invite_url').value
    expect_invite_url = new_travel_member_url(
      travel_id: travel.id, key: travel.generate_invite_key)
    assert_equal expect_invite_url, invite_url
  end

  test 'can add member' do
    current_user = users(:google)
    twitter_user = users(:twitter)
    other_user_travel = Travel.mine(twitter_user).first
    assert_not_includes other_user_travel.members, current_user.id

    invite_url = new_travel_member_url(
      travel_id: other_user_travel.id, key: other_user_travel.generate_invite_key)
    visit invite_url
    other_user_travel.reload
    assert_includes other_user_travel.members, current_user.id

    visit travels_path
    assert_match other_user_travel.name, page.text
  end

  test 'can remove member' do
    travel = Travel.order('updated_at DESC').first
    twitter_user = users(:twitter)
    travel.update!(members: (travel.members << twitter_user.id).uniq)

    first("a[title='編集']").click
    click_link 'メンバー管理'

    assert_match twitter_user.name, page.text
  end
end
