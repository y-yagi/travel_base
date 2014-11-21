json.array!(@travels) do |travel|
  json.extract! travel, :id, :name, :memo, :start_date, :end_date, :deleted_at, :user_id
  json.url travel_url(travel, format: :json)
end
