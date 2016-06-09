# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  uid        :string           not null
#  provider   :string           not null
#  name       :string           not null
#  email      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  include Api::User

  has_one :photo_service_user_info, dependent: :destroy
  has_many :places, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :travels, foreign_key: 'owner_id', dependent: :destroy
  has_many :todos, dependent: :destroy
  has_many :deleted_data, dependent: :destroy

  validates :uid, presence: true
  validates :name, presence: true
  validates :provider, presence: true

  accepts_nested_attributes_for :photo_service_user_info

  before_save :encrypt_device_token

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
        u.name = acquire_name_from_auth_hash(auth)
      end
    end

    def acquire_name_from_auth_hash(auth)
      case auth['provider']
      when 'twitter', 'facebook'
        auth['info']['nickname'].presence || auth['info']['name']
      else
        auth['info']['name']
      end
    end

    def authenticate!(user_id: nil, provider: nil)
      return nil if user_id.blank? || provider.blank?

      if provider == 'google_oauth2'
        User.find_by(email: user_id, provider: provider)
      else
        User.find_by(uid: user_id, provider: provider)
      end
    end
  end

  def update_if_needed!(auth)
    new_email = auth['info']['email']
    if new_email.present? && email != new_email
      self.email = new_email
    end

    new_name = User.acquire_name_from_auth_hash(auth)
    if new_name.present? && name != new_name
      self.name = new_name
    end
    save! if changed?
  end

  def encrypt_device_token
    if device_token_changed? && device_token.present?
      self.device_token = Rails.application.message_verifier(:device_token).generate(device_token)
    end
  end

  def raw_device_token
    Rails.application.message_verifier(:device_token).verify(device_token)
  end
end
