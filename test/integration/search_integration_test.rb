require 'test_helper'
require 'elasticsearch/extensions/test/cluster'
require 'elasticsearch/extensions/test/cluster'

class SearchIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    Capybara.current_driver = Capybara.javascript_driver

    unless Elasticsearch::Extensions::Test::Cluster.running?
      Elasticsearch::Extensions::Test::Cluster.start(nodes: 1)
    end
    Place.__elasticsearch__.create_index!
    login
  end

  def teardown
    Capybara.current_driver = Capybara.default_driver
    Elasticsearch::Extensions::Test::Cluster.stop
  end

  test 'can search places that login user created' do
    within(:css, "form.quick-search") do
      fill_in 'search', with: '神社'
    end
    find('.quick-search').trigger('click')

    assert_match '大麻比古神社', page.text
    assert_match '貴船神社', page.text
    assert_no_match '上賀茂神社', page.text
  end
end
