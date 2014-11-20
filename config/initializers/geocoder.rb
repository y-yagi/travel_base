Geocoder.configure(
  timeout:  3,
  lookup: :google,
  language: :ja,
  use_https: true,
  api_key: ENV['GOOGLE_MAP_API_KEY'],
  unit: :km,       # :km for kilometers or :mi for miles
  cache: Redis.new,
  # :cache_prefix => "geocoder:", # prefix (string) to use for all cache keys
  # calculation options
  # :distances => :linear    # :spherical or :linear
)
