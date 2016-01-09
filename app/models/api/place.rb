module Api::Place
  extend ActiveSupport::Concern

  included do
    include Garage::Representer
    include Garage::Authorizable

    property :id
    property :name
    property :address
    property :memo
    property :latitude
    property :longitude
    property :station_info
    property :url
    property :status

    def self.build_permissions(perms, other, target)
      perms.permits! :read if perms.user == other
      perms.permits! :write if perms.user == other
    end

    def build_permissions(perms, other)
      perms.permits! :read if perms.user == other
      perms.permits! :write if perms.user == other
    end

    def station_info
      places_station.each.sum do |ns|
        "#{ns.station.line} #{ns.station.name}駅 #{ns.distance}\n"
      end
    end

    def url
      urls.try(:join, ",").to_s
    end
  end
end
