require 'test_helper'

class MapIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    login
  end

  test 'include place info' do
    user = users(:google)
    place = user.places.first
    visit map_place_path(place)

    assert_match place.name, page.html
  end

  test 'include places info' do
    user = users(:google)
    visit map_places_path

    places = user.places.order('updated_at DESC').not_gone.limit(5)
    places.each do |place|
      assert_match place.name, page.html
    end
  end

  test 'include travel places' do
    user = users(:google)
    travel = travels(:kyoto)
    visit map_schedule_path(travel_date_id: travel.travel_dates.first.id)

    travel_dates.each do |travel_date|
      assert_match travel_date.schedule.place.name, page.html
    end
  end
end
