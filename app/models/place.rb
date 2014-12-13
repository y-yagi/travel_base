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

  validates :name, presence: true, length: { maximum: 255 }
  validates :address, presence: true
  validates :user_id, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  class << self
    def build(params, user)
      place = new(params)
      place.user_id = user.id
      set_geoinfo(place) if params[:latitude].blank?
      place
    end

    def set_geoinfo(place)
      geo_info = Geocoder.search(place.address)
      return if geo_info.empty?

      place.latitude = geo_info.first.geometry['location']['lat']
      place.longitude = geo_info.first.geometry['location']['lng']
    end
  end
end
