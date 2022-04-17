require 'net/http'
require 'json'

class NasaApodApi
  def self.fetch_apod_data
    nasa_uri = URI("https://api.nasa.gov/planetary/apod?api_key=#{ENV['NASA_APOD_API_KEY']}")
    response = Net::HTTP.get(nasa_uri)
    apod_data = JSON.parse(response)
  end
end
