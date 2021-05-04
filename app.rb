#!/usr/bin/env ruby

require 'dotenv/load'
require 'net/http'

Dotenv.require_keys('API_KEY')

uri = URI('https://api.nasa.gov/planetary/apod')
params = {api_key: ENV['API_KEY']}
uri.query = URI.encode_www_form(params)
puts Net::HTTP.get(uri)
