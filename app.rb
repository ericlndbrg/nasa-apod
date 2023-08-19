#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'classes/user_input_validator'
require_relative 'classes/nasa_apod_api'
require_relative 'classes/image_downloader'
require_relative 'classes/apod_already_downloaded_error'
require_relative 'classes/apod_unavailable_error'
require 'byebug'

def main
  # validate the user's input
  input_validator = UserInputValidator.new(ARGF.argv)
  input_validator.validate_user_input

  apod_date = input_validator.user_input[0]

  # check to see if the APOD for apod_date has already been downloaded
  #   if so, don't bother NASA
  Dir.foreach('images') do |filename|
    raise(ApodAlreadyDownloadedError, "Already downloaded the APOD for #{apod_date}") if filename.match?(apod_date)
  end

  # fetch the APOD metadata for apod_date from NASA
  nasa_apod_api = NasaApodApi.new(apod_date)
  fetched_apod_data = nasa_apod_api.apod_api_response

  # fetched_apod_data will be set to nil if the APOD for apod_date isn't an image
  # this app doesn't attempt to download non-image APODs
  raise(ApodUnavailableError, "No APOD is available for #{apod_date}") if fetched_apod_data.nil?

  # attempt to download the APOD for apod_date
  image_downloader = ImageDownloader.new(fetched_apod_data)
  image_downloader.download_images

rescue InvalidUserInputError, Date::Error, ApodAlreadyDownloadedError, ApodUnavailableError => error
  # notify the user of foreseeable problems
  puts error.message
end

main
