class Place < ApplicationRecord
  include Api::Place
  include Recorder

  belongs_to :user
  has_one :event, dependent: :destroy
  has_many :places_station
  has_many :schedules, dependent: :destroy

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

  paginates_per 10

  class << self
    def build(params, user)
      place = new(params)
      place.user_id = user.id
      place.set_geoinfo! if params[:latitude].blank? && params[:address].present?
      place
    end

    def acquire_by_params(user, params)
      places = user.places.order('updated_at DESC')
      if params[:already]
        places = places.already_went.page(params[:page])
      else
        places = places.not_gone.page(params[:page])
      end
      places = places.tag(params[:tag]) if params[:tag]

      places
    end

    def get_address_from_geocode_result(place)
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

  def prefecture
    address.try! { match(/\A(.{2}[都道府県]|.{3}県)/).to_s }
  end
end
