#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'classes/user_input_validator'
require_relative 'classes/nasa_apod_api'
require_relative 'classes/image_downloader'
require_relative 'classes/date_validation_error'
require 'byebug'

def main
  validator = UserInputValidator.new(ARGF.argv)
  validator.validate_user_input
  valid_user_input =
    if validator.user_input.count > 1
      validator.user_input.sort
    else
      validator.user_input
    end

  nasa_apod_api = NasaApodApi.new(valid_user_input)
  apod_data = nasa_apod_api.apod_response

  return if apod_data.empty?
  # raise(NoApodError, 'No APOD exists for date(s)') if apod_data.empty?

  image_downloader = ImageDownloader.new(apod_data)
  image_downloader.download_images

rescue DateValidationError => e
  puts "#{e.class} - #{e.message}"
end

main
