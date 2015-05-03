module Api::Place
  extend ActiveSupport::Concern

  included do
    include Garage::Representer
    property :id
    property :name
    property :memo
    property :latitude
    property :longitude
  end
end
