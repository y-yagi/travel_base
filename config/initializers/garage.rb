Garage.configure {}

Garage::TokenScope.configure do
  register :public, desc: 'acessing publicly available data' do
    access :read, Travel
  end
end

Doorkeeper.configure do
  orm :active_record
  default_scopes :public
  optional_scopes(*Garage::TokenScope.optional_scopes)
  grant_flows %w(password)
  access_token_expires_in nil

  resource_owner_from_credentials do |routes|
    User.authenticate!(params)
  end
end

