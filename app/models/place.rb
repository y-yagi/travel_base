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
#  urls       :string           is an Array
#  user_id    :integer          not null
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tags       :string           is an Array
#

class Place < ActiveRecord::Base
  include Api::Place
  include Recorder

  belongs_to :user
  has_many :places_station
  has_many :schedules, dependent: :destroy

  scope :mine, ->(user) { where(user_id: user.id) }
  scope :tag, ->(tag) do
    where('tags @> ARRAY[?]::varchar[]', [tag])
  end
  scope :registered_recently, -> do
    not_gone.order('created_at DESC').limit(5)
  end

  enum status: [ :not_gone, :already_went ]

  validates :name, presence: true, length: { maximum: 255 }
  validates :address, presence: true
  validates :user_id, presence: true
  validates :latitude, presence: true, if: -> { address.present? }
  validates :longitude, presence: true, if: -> { address.present? }

  after_destroy :record_deleted_datum

  paginates_per 10

  class << self
    def build(params, user)
      place = new(params)
      place.user_id = user.id
      place.set_geoinfo! if params[:latitude].blank? && params[:address].present?
      place
    end

    def search_fields
      ['name', 'address', 'memo', 'tags']
    end

    def acquire_by_params(user, params)
      places = Place.mine(user).order('updated_at DESC')
      if params[:already]
        places = places.already_went.page(params[:page])
      else
        places = places.not_gone.page(params[:page])
      end
      places = places.tag(params[:tag]) if params[:tag]

      places
    end

    def get_address_form_geocode_result(place)
      # 最初の国名が含まれるので、国名のみ削除する
      # また、郵便番号が含まれる場合、郵便番号も削除
      place.formatted_address.split(' ', 2).second.try { gsub(/^〒[0-9-]+ /, '') }
    end
  end

  def set_geoinfo!
    geo_info = Geocoder.search(address)
    return if geo_info.empty?
    self.latitude = geo_info.first.geometry['location']['lat']
    self.longitude = geo_info.first.geometry['location']['lng']
  end

  def set_station_info
    return unless places_station.empty? || address_changed?

    begin
      stations = HeartRailsExpressApi.get_stations(latitude, longitude)
      PlacesStation.build_from_api_result!(self, stations)
    rescue => e
      logger.error(e)
      Rollbar.error(e, "can't create station data")
    end
  end
end
