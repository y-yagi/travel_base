module Api::Travel
  extend ActiveSupport::Concern

  included do
    include Garage::Representer
    include Garage::Authorizable

    property :id
    property :name
    collection :travel_dates, selectable: true

    def self.build_permissions(perms, other, target)
      perms.permits! :read if perms.user == other
    end

    def build_permissions(perms, other)
      perms.permits! :read if perms.user == other
    end
  end
end
