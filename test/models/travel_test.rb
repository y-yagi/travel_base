# == Schema Information
#
# Table name: travels
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  memo       :text
#  start_date :date
#  end_date   :date
#  owner_id   :integer          not null
#  members    :integer          is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class TravelTest < ActiveSupport::TestCase
  test 'should have the necessary required validators' do
    travel = Travel.new
    assert_not travel.valid?
    assert_equal [:name, :start_date, :end_date, :owner_id], travel.errors.keys
  end

  test 'validate error when set 256 character in name' do
    travel = Travel.new(name: 'a' * 256)
    assert_not travel.valid?
    assert_includes travel.errors.keys, :name
  end

  test 'can set 255 character in name' do
    travel = Travel.new(name: 'a' * 255)
    assert_not travel.valid?
    assert_not_includes travel.errors.keys, :name
  end

  test 'validate error when set start_date greater than end_date' do
    travel = Travel.new(start_date: 1.days.ago, end_date: 2.days.ago)
    assert_not travel.valid?
    assert_includes travel.errors.keys, :end_date
  end

  test 'build method return Travel instance' do
    params = ActionController::Parameters.new(name: 'test', memo: 'memo')
    params.permit!
    travel = Travel.build(params, users(:google))
    assert_instance_of Travel, travel
  end

  test 'owner_id be set in current user'  do
    params = ActionController::Parameters.new(name: 'test', memo: 'memo')
    params.permit!
    travel = Travel.build(params, users(:google))

    assert_equal travel.owner_id,  users(:google).id
  end

  test 'current user be included in members' do
    params = ActionController::Parameters.new(name: 'test', memo: 'memo')
    params.permit!
    travel = Travel.build(params, users(:google))

    assert_includes travel.members, users(:google).id
  end

  test 'return true when user exists in members' do
    travel = travels(:kyoto)
    assert travel.member?(users(:facebook).id)
  end

  test 'return false when travel is future' do
    assert_not travels(:kyoto).past?
  end

  test 'return true when travel is past' do
    assert travels(:okayama).past?
  end

  test 'traves dates being made based on start date and end date' do
    travel = Travel.create!(
      name: 'test', memo: 'memo', start_date: 3.days.since, end_date: 5.days.since,
      owner_id: users(:google).id
    )

    dates = travel.travel_dates.map(&:date)
    assert_equal 3, dates.size
    assert_equal [3.days.since.to_date, 4.days.since.to_date,
      5.days.since.to_date], dates
  end


  test 'remove old traves dates when update travel dates' do
    travel = Travel.create!(
      name: 'test', memo: 'memo', start_date: 3.days.since, end_date: 5.days.since,
      owner_id: users(:google).id
    )

    travel.update!(start_date: 5.days.since, end_date: 6.days.since)
    travel.reload

    dates = travel.travel_dates.map(&:date)
    assert_equal 2, dates.size
    assert_equal [5.days.since.to_date, 6.days.since.to_date], dates
  end

  test 'can get icalendar data' do
    ics = travels(:kyoto).to_ics

    assert_match 'SUMMARY:京都旅行', ics
  end

  test 'if you have automatic archiving to true, the finished travel is archived' do
    users(:google).update!(auto_archive: true)
    past_travel = travels(:okayama)

    past_travel.places.each do |place|
      assert place.not_gone?
    end

    Travel.archive_places!
    past_travel.reload

    past_travel.places.each do |place|
      assert place.already_went?
    end
  end

  test 'if the automatic archiving you have to false, and that was the end travel is not archived' do
    users(:google).update!(auto_archive: false)
    past_travel = travels(:okayama)

    past_travel.places.each do |place|
      assert place.not_gone?
    end

    Travel.archive_places!
    past_travel.reload

    past_travel.places.each do |place|
      assert place.not_gone?
    end
  end

  test 'deleted data is recorded' do
    travel= Travel.first
    travel.destroy!

    deleted_datum = DeletedDatum.last

    assert_equal 'travels', deleted_datum.table_name
    assert_equal travel.id, deleted_datum.datum_id
    assert_equal travel.owner_id, deleted_datum.user_id
  end
end
