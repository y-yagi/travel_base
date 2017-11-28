require 'application_system_test_case'

class SearchTest < ApplicationSystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  setup do
    login
    visit root_path
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
