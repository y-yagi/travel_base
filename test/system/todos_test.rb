require 'application_system_test_case'

class TodosTest < ApplicationSystemTestCase
  setup do
    login
    visit travel_todos_path(travels(:kyoto))
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


  sub_test_case 'with JS' do
    driven_by :selenium_chrome_headless

    test 'finish todo' do
      todo = todos(:kyoto_todo)
      assert_not todo.finished

      page.find(:xpath, %|//input[@id="todo_#{todo.id}"]/..|).click

      wait_for_ajax
      assert todo.reload.finished
    end

    test 'destroy todo' do
      first("a[title='削除']").click
      page.driver.browser.switch_to.alert.accept

      assert_no_match '京都チケット予約', page.text
    end
  end
end
