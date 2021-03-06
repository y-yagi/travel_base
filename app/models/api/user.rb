module Api::User
  extend ActiveSupport::Concern

  included do
    include Garage::Representer
    include Garage::Authorizable

    property :id

    def self.build_permissions(perms, other, target)
      perms.permits! :read if perms.user == other
      perms.permits! :write if perms.user == other
    end

    def build_permissions(perms, other)
      perms.permits! :read if perms.user == other
      perms.permits! :write if perms.user == other
    end
  end
end
