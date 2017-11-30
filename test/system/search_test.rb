require 'application_system_test_case'

class SearchTest < ApplicationSystemTestCase
  driven_by :selenium, using: :headless_chrome

  setup do
    login
    visit root_path
  end

  test 'can search places that login user created' do
    find('.icon-search').click
    fill_in 'search', with: '神社'
    find('#search').native.send_keys(:return)

    assert_match '大麻比古神社', page.text
    assert_match '貴船神社', page.text
    assert_no_match '上賀茂神社', page.text
  end
end
