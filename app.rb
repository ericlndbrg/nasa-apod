#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'classes/user_input_validator'
require_relative 'classes/nasa_apod_api'
# require_relative 'classes/image_downloader'
# require_relative 'classes/date_validation_error'
require 'byebug'

def main
  input_validator = UserInputValidator.new(ARGF.argv)
  input_validator.validate_user_input

  apod_date = input_validator.user_input[0]

  # check if I've already got the image for apod_date
  # raise(StandardError, "Already downloaded the APOD for #{apod_date}") if File.exists?blahblahblah

  nasa_apod_api = NasaApodApi.new(apod_date)
  apod_data = nasa_apod_api.apod_response

  raise(StandardError, "No APOD is available for #{apod_date}") if apod_data.nil?

#   image_downloader = ImageDownloader.new(apod_data)
#   image_downloader.download_images
end

main
