json.array!(@users) do |user|
  json.extract! user, :id, :uid, :provider, :name, :email, :deleted_at
  json.url user_url(user, format: :json)
end
