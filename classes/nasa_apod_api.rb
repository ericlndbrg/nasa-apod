# frozen_string_literal: true

require 'net/http'
require 'json'

# handles calls to the NASA APOD API
class NasaApodApi
  def initialize(date)
    self.date = date
  end

  def apod_response
    api_response_hash = get_api_response(build_uri)
    return nil unless api_response_hash['media_type'] == 'image'

    api_response_hash
  end

  private

  attr_accessor :date

  def build_uri
    query_string = URI.encode_www_form({ api_key: ENV['NASA_APOD_API_KEY'], date: date })
    URI("https://api.nasa.gov/planetary/apod?#{query_string}")
  end

  def get_api_response(uri)
    JSON.parse(Net::HTTP.get(uri))
  end
end
