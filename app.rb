#!/usr/bin/env ruby

require 'dotenv/load'
require 'date'
require_relative 'classes/nasa_apod_api'

Dotenv.require_keys('API_KEY')

today = Date.today.strftime('%Y-%m-%d')
if Dir.glob("#{today}*", base: './images/').empty?
  apod = NasaApodApi.new
  nasa_response = apod.fetch_image_uri_and_title
  apod.download_image(nasa_response[:hdurl], nasa_response[:title], today)
else
  puts "The image for today (#{today}) has already been downloaded."
end
