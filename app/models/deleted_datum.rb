class DeletedDatum < ActiveRecord::Base
  include Api::DeletedDatum

  scope :mine, ->(user) { where(user_id: user.id) }

end
