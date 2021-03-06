Garage.configure {}
Garage::TokenScope.configure do
  register :public, desc: 'acessing publicly available data' do
    access :read, Travel
    access :read, Place
    access :write, Place
    access :read, DeletedDatum
    access :read, Event
    access :write, User
  end
end
Garage.configuration.strategy = Garage::Strategy::Doorkeeper

Doorkeeper.configure do
  orm :active_record
  default_scopes :public
  optional_scopes(*Garage::TokenScope.optional_scopes)
  access_token_expires_in nil

  resource_owner_authenticator do |routes|
    User.authenticate!(params)
  end
end
