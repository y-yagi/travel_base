class PhotoServiceUserInfo < ActiveRecord::Base
  belongs_to :user
  enum service_type: [ :picasa, :flicker ]
end
