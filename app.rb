#!/usr/bin/env ruby

require 'dotenv/load'
require 'net/http'
require 'json'

Dotenv.require_keys('API_KEY')

uri = URI('https://api.nasa.gov/planetary/apod')
params = {api_key: ENV['API_KEY']}
uri.query = URI.encode_www_form(params)

response = JSON.parse(Net::HTTP.get(uri))
if response['media_type'] == 'image'
  puts response['hdurl']
  puts response['title']
else
  puts "The response for #{response['date']} is a #{response['media_type']}, not an image."
end
