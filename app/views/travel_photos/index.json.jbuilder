json.array!(@travel_photos) do |travel_photo|
  json.extract! travel_photo, :id, :travel_id, :photo_service_user_info_id, :photo_service_album_id
  json.url travel_photo_url(travel_photo, format: :json)
end
