class PhotoServiceInfoWrapper
  class << self
    def get_client(user_info)
      if user_info && user_info.picasa?
        Picasa::Client.new(user_id: user_info.photo_service_user_id)
      else
        nil
      end
    end
  end
end
