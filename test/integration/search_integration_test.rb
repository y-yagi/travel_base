require 'test_helper'

class SearchIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    Capybara.current_driver = Capybara.javascript_driver
    login
    visit root_path
  end

  teardown do
    Capybara.current_driver = Capybara.default_driver
  end

  test 'can search places that login user created' do
    find('#nav-toggle').click
    fill_in 'search', with: '神社'
    find('.icon-search').click

    assert_match '大麻比古神社', page.text
    assert_match '貴船神社', page.text
    assert_no_match '上賀茂神社', page.text
  end
end
