class PhotoServiceUserInfo < ApplicationRecord
  belongs_to :user
  has_many :travel_photos, dependent: :destroy

  # TODO: add other photo service
  enum service_type: [ :picasa ]

end
