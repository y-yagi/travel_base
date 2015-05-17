module Api::Schedule
  extend ActiveSupport::Concern

  included do
    include Garage::Representer
    property :id
    property :memo
    property :start_time
    property :formatted_start_time
    property :end_time
    property :formatted_end_time
    property :place
    property :route

    def formatted_start_time
      start_time.try(:strftime, "%H:%M")
    end

    def formatted_end_time
      end_time.try(:strftime,  "%H:%M")
    end
  end
end
