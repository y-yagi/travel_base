require 'test_helper'
require 'active_support/testing/metadata'

class TodoIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    if metadata[:js]
      Capybara.current_driver = Capybara.javascript_driver
    else
      Capybara.current_driver = Capybara.default_driver
    end

    login
    visit travel_todos_path(travels(:kyoto))
  end

  def teardown
    Capybara.current_driver = Capybara.default_driver
  end

  test 'display todos that I registered in list' do
    assert_match '京都チケット予約', page.text
    assert_match 1.days.since.strftime("%m/%d"), page.text
    assert_no_match '岡山チケット予約', page.text
  end

  test 'create todo' do
    fill_in 'todo_detail', with: '行くところの整理'
    select Date.today.year, from: 'todo_deadline_at_1i'
    select "#{Date.today.month}月", from: 'todo_deadline_at_2i'
    select Date.today.day, from: 'todo_deadline_at_3i'

    assert_difference 'Todo.count' do
      click_button '登録'
    end
    assert_match '行くところの整理', page.text
    assert_match Date.today.strftime("%m/%d"), page.text
  end

  test 'finish todo', js: true do
    todo = todos(:kyoto_todo)
    assert_not todo.finished

    page.find(:xpath, %|//input[@id="todo_#{todo.id}"]/..|).trigger('click')
    wait_for_ajax
    assert todo.reload.finished
  end

  test 'destroy todo' do
    first("a[title='削除']").click

    assert_no_match '京都チケット予約', page.text
  end
end
