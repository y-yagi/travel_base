class Schedule < ActiveRecord::Base
  belongs_to :travel_date, dependent: :destroy
  belongs_to :place

  class << self
    def build(params)
      new(params)
    end
  end
end
