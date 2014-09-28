Geocoder.configure(
  timeout:  3,           # geocoding service timeout (secs)
  lookup: :google,     # name of geocoding service (symbol)
  language: :ja,         # ISO-639 language code
  # :use_https    => false,       # use HTTPS for lookup requests? (if supported)
  # :api_key      => nil,         # API key for geocoding service
  # :cache        => nil,         # cache object (must respond to #[], #[]=, and #keys)
  # :cache_prefix => "geocoder:", # prefix (string) to use for all cache keys

  # exceptions that should not be rescued by default
  # (if you want to implement custom error handling);
  # supports SocketError and TimeoutError
  # :always_raise => [],

  # calculation options
  unit: :km,       # :km for kilometers or :mi for miles
  # :distances => :linear    # :spherical or :linear
  #
  cache: Redis.new,
)
