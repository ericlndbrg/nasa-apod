#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'classes/user_input_validator'
# require_relative 'classes/nasa_apod_api'
# require_relative 'classes/image_downloader'
# require_relative 'classes/date_validation_error'
require 'byebug'

def main
  input_validator = UserInputValidator.new(ARGF.argv)
  input_validator.validate_user_input

  apod_date = input_validator.user_input[0]
  puts '*' * 200
  puts "apod_date is valid: #{apod_date}"
  puts '*' * 200

#   nasa_apod_api = NasaApodApi.new(valid_user_input)
#   apod_data = nasa_apod_api.apod_response

#   return if apod_data.empty?
#   # raise(NoApodError, 'No APOD exists for date(s)') if apod_data.empty?

#   image_downloader = ImageDownloader.new(apod_data)
#   image_downloader.download_images
end

main
