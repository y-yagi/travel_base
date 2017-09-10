class Route < ApplicationRecord
  include Api::Route

  has_one :schedule, dependent: :destroy

  after_save do |route|
    route.schedule.travel_date.travel.touch
  end
end
