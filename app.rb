#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'classes/user_input_validator'
require_relative 'classes/nasa_apod_api'
require_relative 'classes/image_downloader'
require_relative 'classes/apod_already_downloaded_error'
require_relative 'classes/apod_unavailable_error'
require 'byebug'

def main
  input_validator = UserInputValidator.new(ARGF.argv)
  input_validator.validate_user_input

  apod_date = input_validator.user_input[0]

  Dir.foreach('images') do |filename|
    raise(ApodAlreadyDownloadedError, "Already downloaded the APOD for #{apod_date}") if filename.match?(apod_date)
  end

  nasa_apod_api = NasaApodApi.new(apod_date)
  fetched_apod_data = nasa_apod_api.apod_api_response

  raise(ApodUnavailableError, "No APOD is available for #{apod_date}") if fetched_apod_data.nil?

  image_downloader = ImageDownloader.new(fetched_apod_data)
  image_downloader.download_images
end

main
