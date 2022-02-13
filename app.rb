#!/usr/bin/env ruby

def main
  require 'dotenv/load'
  require_relative 'classes/nasa_apod_api'
  require_relative 'classes/image_downloader'

  image_directory = File.realdirpath('images')

  Dotenv.require_keys('API_KEY')

  apod = NasaApodApi.new
  apod.fetch_apod_image_url_and_filename

  if File.exist?("#{image_directory}/#{apod.image_filename}")
    raise(StandardError, 'Today\'s image has already been downloaded.')
  else
    ImageDownloader.download_image(apod.image_url, apod.image_filename, image_directory)
  end

  rescue StandardError => e
    puts e.message
end

main
