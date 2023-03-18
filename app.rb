#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'classes/user_input_validator'
require_relative 'classes/nasa_apod_api'
require_relative 'classes/image_downloader'
require 'byebug'

def main
  validator = UserInputValidator.new(ARGF.argv)
  validator.validate

  nasa_apod_api = NasaApodApi.new(validator.user_input)
  apod_data = nasa_apod_api.apod_response

  return if apod_data.empty?

  image_downloader = ImageDownloader.new(apod_data)
  image_downloader.download_images
end

main
