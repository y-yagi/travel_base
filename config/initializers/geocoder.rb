Geocoder.configure(
  timeout:  5,
  lookup: :google,
  language: :ja,
  use_https: true,
  api_key: ENV['GOOGLE_MAP_API_KEY'],
  unit: :km
)
