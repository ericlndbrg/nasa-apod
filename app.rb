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
  apod_image_data = nasa_apod_api.apod_image_data
  nasa_apod_api.sit_rep

  return if apod_image_data.empty?

  image_downloader = ImageDownloader.new(apod_image_data)
  image_downloader.download_images
  image_downloader.sit_rep
end

main
