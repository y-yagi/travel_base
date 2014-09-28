json.array!(@places) do |place|
  json.extract! place, :id, :name, :address, :memo, :latitude, :longitude, :website, :deleted_at, :user_id
  json.url place_url(place, format: :json)
end
