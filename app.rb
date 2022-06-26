#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'classes/user_input_validator'
require_relative 'classes/nasa_apod_api'
require_relative 'classes/image_downloader'

def main
  validator = UserInputValidator.new(ARGF.argv)
  validator.validate

  nasa_apod_api = NasaApodApi.new(validator.user_input)
  apod_images = nasa_apod_api.apod_image_data
  nasa_apod_api.report_progress

  return if apod_images.empty?

  image_downloader = ImageDownloader.new(apod_images)
  image_downloader.download_images
  image_downloader.report_progress
end

main
