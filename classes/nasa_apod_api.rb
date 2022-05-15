require 'net/http'
require 'json'

class NasaApodApi
  def self.fetch_apod_data(dates)
    apod_data = []
    dates.each do |date|
      nasa_uri = URI("https://api.nasa.gov/planetary/apod?api_key=#{ENV['NASA_APOD_API_KEY']}&date=#{date}")
      response = Net::HTTP.get(nasa_uri)
      response_as_hash = JSON.parse(response)
      apod_data.push(response_as_hash)
    end
    apod_data
  end
end
