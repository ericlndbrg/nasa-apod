# frozen_string_literal: true

require 'net/http'
require 'json'

# handles calls to the NASA APOD API
class NasaApodApi
  def initialize(dates)
    self.dates = dates
  end

  def apod_response
    get_api_response(build_uri)
  end

  private

  attr_accessor :dates

  def build_uri
    query_string = URI.encode_www_form(build_uri_query_string)
    URI("https://api.nasa.gov/planetary/apod?#{query_string}")
  end

  def build_uri_query_string
    uri_query = { api_key: ENV['NASA_APOD_API_KEY'] }
    return uri_query.merge({ date: dates[0] }) if dates.count == 1

    uri_query.merge({ start_date: dates[0], end_date: dates[1] })
  end

  def get_api_response(uri)
    # if the app was ran with a single date or no date, returns a hash
    # if the app was ran with two dates, returns an array of hashes
    # this method's return object must be an array for the image downloader to work
    api_response = JSON.parse(Net::HTTP.get(uri))
    return api_response if api_response.is_a?(Array)
    
    [].push(api_response)
  end
end
