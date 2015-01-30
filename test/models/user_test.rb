require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should have the necessary required validators' do
    user = User.new
    assert_not user.valid?
    assert_equal [:uid, :name, :provider], user.errors.keys
  end

  test 'return exist user data when provider and uid match' do
    auth = { 'provider' => 'google', 'uid' => 1 }
    user = User.find_or_create_from_auth_hash(auth)

    assert_equal users(:google).id, user.id
  end

  test 'return new user data when provider and uid not match' do
    auth = {
      'provider' => 'google', 'uid' => 2,
      'info' => { 'email' => 'test2@google.com', 'name' => 'test2' }
    }
    user = User.find_or_create_from_auth_hash(auth)

    assert_not_equal users(:google).id, user.id
  end
end
