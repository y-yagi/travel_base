# == Schema Information
#
# Table name: schedules
#
#  id             :integer          not null, primary key
#  memo           :text
#  start_time     :datetime         not null
#  end_time       :datetime         not null
#  travel_date_id :integer          not null
#  place_id       :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Schedule < ActiveRecord::Base
  belongs_to :travel_date
  belongs_to :place
  belongs_to :route

  validates :travel_date_id, presence: true
  validates :place_id, presence: true

  class << self
    def build(params)
      new(params)
    end
  end
end
