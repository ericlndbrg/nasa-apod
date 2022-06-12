#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'classes/user_input_validator'
require_relative 'classes/nasa_apod_api'
require_relative 'classes/image_downloader'

def main
  validator = UserInputValidator.new(ARGF.argv)
  validator.validate

  nasa_apod_api = NasaApodApi.new(validator.user_input)
  nasa_api_response = nasa_apod_api.fetch_apod_data

  image_downloader = ImageDownloader.new(nasa_api_response)
  image_downloader.download_images
end

main
