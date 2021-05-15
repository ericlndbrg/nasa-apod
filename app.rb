#!/usr/bin/env ruby

require 'dotenv/load'
require_relative 'classes/nasa_apod_api'
require_relative 'classes/image_downloader'

Dotenv.require_keys('API_KEY')

begin
  apod = NasaApodApi.new
  image_hdurl, todays_image_filename = apod.fetch_nasa_apod_response
  if File.exist?("./images/#{todays_image_filename}")
    puts 'Today\'s image has already been downloaded.'
  else
    ImageDownloader.download_image(image_hdurl, todays_image_filename)
  end
rescue NoMethodError
  puts "Today\'s APOD is not an image."
end
