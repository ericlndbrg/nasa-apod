require 'net/http'
require 'json'

class NasaApodApi
  attr_reader :dates, :base_uri

  def initialize(dates)
    @dates = dates
    @base_uri = "https://api.nasa.gov/planetary/apod?api_key=#{ENV['NASA_APOD_API_KEY']}"
  end

  def fetch_apod_data
    apod_data = []
    self.dates.each do |date|
      full_uri = self.base_uri + "&date=#{date}"
      response = Net::HTTP.get(URI.parse(full_uri))
      response_as_hash = JSON.parse(response)
      apod_data.push(response_as_hash)
    end
    apod_data
  end
end
