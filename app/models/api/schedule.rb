module Api::Schedule
  extend ActiveSupport::Concern

  included do
    include Garage::Representer
    property :id
    property :memo
    property :start_time
    property :end_time
    property :place
    property :route
  end
end
