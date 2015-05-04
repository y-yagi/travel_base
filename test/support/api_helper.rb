module ApiHelper
  def get_access_token(resource_owner_id)
    @access_token = Doorkeeper::AccessToken.create!(
      application_id: oauth_applications(:travel_base).id,
      resource_owner_id: resource_owner_id,
      expires_in: 1.hour,
      scopes: 'public'
    )
  end
end
