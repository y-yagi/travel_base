class HeartRailsExpressApi
  GET_STATIONS_API_URL = 'http://express.heartrails.com/api/json?method=getStations'

  class << self
    def get_stations(latitude, longitude)
      url = "#{GET_STATIONS_API_URL}&y=#{latitude}&x=#{longitude}"
      response = HTTP.get(url)
      JSON.parse(response.body.to_s)
    end
  end
end
