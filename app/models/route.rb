# == Schema Information
#
# Table name: routes
#
#  id         :integer          not null, primary key
#  detail     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Route < ApplicationRecord
  include Api::Route

  has_one :schedule, dependent: :destroy

  after_save do |route|
    route.schedule.travel_date.travel.touch
  end
end
