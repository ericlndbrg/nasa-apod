# frozen_string_literal: true

require_relative 'user_input_validator'
require_relative 'image_downloader'
require_relative 'apod_already_downloaded_error'
require_relative 'apod_not_an_image_error'
require_relative 'apod_metadata_validation_error'
require 'net/http'
require 'json'

# the app
class App
  def initialize(user_input)
    self.apod_date = user_input
  end

  def execute
    # check to see if the APOD for apod_date has already been downloaded
    check_if_apod_downloaded_already

    # ask NASA for the APOD's metadata for apod_date
    fetch_apod_metadata

    # check that apod_metadata has the required fields
    validate_apod_metadata

    # download the APOD, but only if it's an image
    download_apod

    # display the APOD's explanation so that the user can read about the image
    print_explanation
  end

  private

  attr_reader :apod_date
  attr_accessor :apod_metadata

  def apod_date=(user_input)
    @apod_date =
      if user_input.empty?
        Date.today.to_s
      else
        UserInputValidator.new(user_input).validate_user_input
        user_input.first
      end
  end

  def check_if_apod_downloaded_already
    Dir.foreach('images') do |filename|
      if filename.match?(apod_date)
        raise(ApodAlreadyDownloadedError, "Already downloaded the APOD for #{apod_date}")
      end
    end
  end

  def fetch_apod_metadata
    query_string = URI.encode_www_form({ api_key: ENV['NASA_APOD_API_KEY'], date: apod_date })
    uri = URI("https://api.nasa.gov/planetary/apod?#{query_string}")
    self.apod_metadata = JSON.parse(Net::HTTP.get(uri))
  end

  def validate_apod_metadata
    required_keys = ['date', 'url', 'media_type', 'title', 'explanation']
    apod_metadata_keys = apod_metadata.keys

    missing_keys = required_keys.each_with_object([]) do |key, memo|
      memo << key unless apod_metadata_keys.include?(key)
    end

    unless missing_keys.empty?
      raise(ApodMetadataValidationError, "Missing #{missing_keys.count} key(s) from apod_metadata: #{missing_keys.join(', ')}")
    end
  end

  def download_apod
    unless apod_metadata['media_type'] == 'image'
      raise(ApodNotAnImageError, "The APOD for #{apod_date} is not an image")
    end

    ImageDownloader.new(apod_metadata).download_image
  end

  def print_explanation
    puts apod_metadata['explanation']
  end
end
