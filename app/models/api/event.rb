module Api::Event
  extend ActiveSupport::Concern

  included do
    include Garage::Representer
    include Garage::Authorizable

    property :id
    property :name
    property :detail
    property :place_id
    property :start_date
    property :end_date
    property :url

    def self.build_permissions(perms, other, target)
      perms.permits! :read if perms.user == other
    end

    def build_permissions(perms, other)
      perms.permits! :read if perms.user == other
    end
  end
end
