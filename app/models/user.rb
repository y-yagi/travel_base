# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  uid        :string           not null
#  provider   :string           not null
#  name       :string           not null
#  email      :string           not null
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  validates :uid, presence: true
  validates :name, presence: true
  validates :provider, presence: true

  class << self
    def find_or_create_from_auth_hash(auth)
      find_by(provider: auth['provider'], uid: auth['uid']) ||
        create_with_omniauth!(auth)
    end

    def create_with_omniauth!(auth)
      create! do |u|
        u.provider = auth['provider']
        u.uid = auth['uid']
        u.email = auth['info']['email']
        u.name = auth['info']['name'].present? || auth['info']['nickname']
      end
    end
  end
end
