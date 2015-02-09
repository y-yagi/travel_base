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
  has_one :photo_service_user_info, dependent: :destroy
  has_many :places, dependent: :destroy
  has_many :travels, foreign_key: 'owner_id', dependent: :destroy

  validates :uid, presence: true
  validates :name, presence: true
  validates :provider, presence: true

  accepts_nested_attributes_for :photo_service_user_info

  class << self
    def find_or_create_from_auth_hash(auth)
      find_by(provider: auth['provider'], uid: auth['uid']) ||
        create_with_omniauth!(auth)
    end

    def create_with_omniauth!(auth)
      create! do |u|
        u.provider = auth['provider']
        u.uid = auth['uid']
        u.email = auth['info']['email'].presence || ''
        u.name = auth['info']['name'].presence || auth['info']['nickname']
      end
    end
  end
end
