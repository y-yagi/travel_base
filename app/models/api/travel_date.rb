module Api::TravelDate
  extend ActiveSupport::Concern

  included do
    include Garage::Representer
    property :id
    property :date
    collection :schedules
  end
end
