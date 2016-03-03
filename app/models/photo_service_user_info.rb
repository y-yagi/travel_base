# == Schema Information
#
# Table name: photo_service_user_infos
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  service_type          :integer          not null
#  photo_service_user_id :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class PhotoServiceUserInfo < ActiveRecord::Base
  belongs_to :user
  has_many :travel_photos, dependent: :destroy

  # TODO: add other photo service
  enum service_type: [ :picasa ]

end
