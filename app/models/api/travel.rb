module Api::Travel
  extend ActiveSupport::Concern

  included do
    include Garage::Representer
    include Garage::Authorizable

    property :id
    property :name
    property :start_date
    property :end_date
    property :memo
    property :formatted_start_date
    property :formatted_end_date
    collection :travel_dates, selectable: true

    def self.build_permissions(perms, other, target)
      perms.permits! :read if perms.user == other
    end

    def build_permissions(perms, other)
      perms.permits! :read if perms.user == other
    end

    def formatted_start_date
      I18n.l(start_date, format: :long)
    end
    def formatted_end_date
      I18n.l(end_date, format: :long)
    end
  end
end
