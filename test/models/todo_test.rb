require 'test_helper'

class TodoTest < ActiveSupport::TestCase
  test 'should have the necessary required validators' do
    todo = Todo.new
    assert_not todo.valid?
    assert_equal [:travel, :user, :detail], todo.errors.keys
  end

  test 'validate error when set 256 character in name' do
    todo = Todo.new(detail: 'a' * 256)
    assert_not todo.valid?
    assert_includes todo.errors.keys, :detail
  end

  test 'build method return Todo instance' do
    params = ActionController::Parameters.new(detail: 'やること')
    params.permit!
    todo = Todo.build(params, users(:google), travels(:kyoto).id)
    assert_instance_of Todo, todo
    assert_equal todo.user_id, users(:google).id
    assert_equal todo.travel_id, travels(:kyoto).id
  end
end
