# frozen_string_literal: true

require 'net/http'
require 'json'

# handles calls to the NASA APOD API
class NasaApodApi
  attr_reader :processed_image_data

  RELEVANT_APOD_ATTRS = %w[title hdurl url].freeze

  def initialize(dates)
    self.dates = dates
    self.uri = build_uri
    self.apod_image_data = get_apod_images
    self.processed_image_data = remove_unused_attrs
  end

  private

  attr_accessor :dates, :uri, :apod_image_data
  attr_writer :processed_image_data

  def build_uri
    query_string = URI.encode_www_form(build_uri_query_string)
    URI("https://api.nasa.gov/planetary/apod?#{query_string}")
  end

  def build_uri_query_string
    uri_query = { api_key: ENV['NASA_APOD_API_KEY'] }
    return uri_query.merge({ date: self.dates[0] }) if self.dates.count == 1

    uri_query.merge({ start_date: self.dates[0], end_date: self.dates[1] })
  end

  def get_apod_images
    get_api_response.filter { |apod| apod['media_type'] == 'image' }
  end

  def get_api_response
    # if the app was ran with a single date or no date, returns a hash
    # if the app was ran with two dates, returns an array of hashes
    # this method's return object must be an array for the image downloader to work
    [JSON.parse(Net::HTTP.get(self.uri))].flatten
  end

  def remove_unused_attrs
    # remove all APOD attrs except for title, hdurl and url
    return nil if self.apod_image_data.empty?

    self.apod_image_data.map do |apod|
      apod.filter { |key, _| RELEVANT_APOD_ATTRS.include?(key) }
    end
  end
end
