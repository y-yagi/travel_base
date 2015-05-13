module ApiHelper
  def get_access_token
    @access_token ||= Doorkeeper::AccessToken.create!(
      application_id: oauth_applications(:travel_base).id,
      expires_in: 1.hour,
      scopes: 'public'
    )
  end
end
