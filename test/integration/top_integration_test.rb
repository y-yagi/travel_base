require 'test_helper'

class TopIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    login
    visit root_path
  end

  test 'display recently registered places in top page' do
    assert_match '最近登録した場所', page.text
    assert_match '大麻比古神社', page.text
    assert_match '伏見稲荷大社', page.text
    assert_no_match '上賀茂神社', page.text
  end

  test 'display next travel in top page' do
    assert_match '次の旅行は京都旅行', page.text
  end
end
