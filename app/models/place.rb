# == Schema Information
#
# Table name: places
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  address    :string           not null
#  memo       :text
#  latitude   :float
#  longitude  :float
#  website    :string
#  deleted_at :datetime
#  user_id    :integer          not null
#  status     :integer          default("0")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Place < ActiveRecord::Base
  include Elasticsearch::Model

  scope :mine, ->(user) { where(user_id: user.id) }

  enum status: [ :not_gone, :already_went ]

  validates :name, presence: true, length: { maximum: 255 }
  validates :address, presence: true
  validates :user_id, presence: true
  validates :latitude, presence: true, if: -> { address.present? }
  validates :longitude, presence: true, if: -> { address.present? }

  class << self
    def build(params, user)
      place = new(params)
      place.user_id = user.id
      place.set_geoinfo! if params[:latitude].blank? && params[:address].present?
      place
    end
  end

  def set_geoinfo!
    geo_info = Geocoder.search(address)
    return if geo_info.empty?
    self.latitude = geo_info.first.geometry['location']['lat']
    self.longitude = geo_info.first.geometry['location']['lng']
  end
end
