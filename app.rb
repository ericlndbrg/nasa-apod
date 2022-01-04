#!/usr/bin/env ruby

def main
  require 'dotenv/load'
  require_relative 'classes/nasa_apod_api'
  require_relative 'classes/image_downloader'

  Dotenv.require_keys('API_KEY')

  apod = NasaApodApi.new
  apod.fetch_apod_image_url_and_filename

  if File.exist?("./images/#{apod.image_filename}")
    puts 'Today\'s image has already been downloaded.'
  else
    ImageDownloader.download_image(apod.image_url, apod.image_filename)
  end
end

main
