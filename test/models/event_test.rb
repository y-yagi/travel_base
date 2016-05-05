require 'test_helper'

class EventTest < ActiveSupport::TestCase
  test 'should have the necessary required validators' do
    event = Event.new
    assert_not event.valid?
    assert_equal [:user, :place, :name], event.errors.keys
  end

  test 'validate error when set 256 character in name' do
    event = Event.new(name: 'a' * 256)
    assert_not event.valid?
    assert_includes event.errors.keys, :name
  end

  test 'can set 255 character in name' do
    event = Event.new(name: 'a' * 255)
    assert_not event.valid?
    assert_not_includes event.errors.keys, :name
  end

  test 'validate error when set 1025 character in detail' do
    event = Event.new(detail: 'a' * 1025)
    assert_not event.valid?
    assert_includes event.errors.keys, :detail
  end

  test 'can set 1024 character in detail' do
    event = Event.new(name: 'a' * 1024)
    assert_not event.valid?
    assert_not_includes event.errors.keys, :detail
  end

  test 'build method return event instance' do
    params = ActionController::Parameters.new(name: 'tokyo')
    params.permit!
    event = Event.build(params, users(:google))
    assert_instance_of Event, event
    assert_equal event.user_id, users(:google).id
  end

  test 'deleted data is recorded' do
    event = Event.first
    event.destroy!

    deleted_datum = DeletedDatum.last

    assert_equal 'events', deleted_datum.table_name
    assert_equal event.id, deleted_datum.datum_id
    assert_equal event.user_id, deleted_datum.user_id
  end
end
