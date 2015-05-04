module Api::Route
  extend ActiveSupport::Concern

  included do
    include Garage::Representer
    property :id
    property :detail
  end
end
