require 'net/http'
require 'json'

class NasaApodApi
  attr_reader :dates, :base_uri

  def initialize(dates)
    @dates = dates
    @base_uri = "https://api.nasa.gov/planetary/apod?api_key=#{ENV['NASA_APOD_API_KEY']}"
  end

  def fetch_apod_data
    # build uri
    full_uri = build_uri
    # get api response
    api_response = get_api_response(full_uri)
    puts "api_response: #{api_response.inspect}"
    raise
    # process api response
    if api_response.is_a?(Hash)
      # single date, api_response is a hash
      # return an empty array if the response contains a video
      api_response['media_type'] == 'image' ? [api_response] : []
    else
      # date range, api_response is an array of hashes
      # filter out the videos
      api_response.filter { |apod| apod['media_type'] == 'image' }
    end
  end

  private

  def build_uri
    if self.dates.count == 1
      # build uri for a single date
      self.base_uri + "&date=#{self.dates.first}"
    else
      # build uri for a date range
      self.base_uri + "&start_date=#{self.dates.first}" + "&end_date=#{self.dates.last}"
    end
  end

  def get_api_response(uri)
    # if the app was ran with a single date, returns a hash
    # if the app was ran with two dates, returns an array of hashes
    response = Net::HTTP.get(URI.parse(uri))
    JSON.parse(response)
  end
end
