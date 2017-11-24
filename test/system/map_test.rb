require 'application_system_test_case'

class MapTest < ApplicationSystemTestCase
  setup do
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
    travel = travels(:kyoto)
    visit map_schedule_path(travel_date_id: travel.travel_dates.first.id)

    assert_match travel.travel_dates.first.schedules.first.place.name, page.html
  end
end
