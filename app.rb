#!/usr/bin/env ruby

require 'dotenv/load'

Dotenv.require_keys('API_KEY')

class NasaApodApi

  require 'net/http'
  require 'json'
  require 'open3'
  
  attr_accessor :api_response
  
  def get_image_uri
    make_api_request
  end

  def download_image(uri, title)
    stdout, stderr, status = Open3.capture3("wget --output-document=2021-05-09:#{title}.jpg #{uri}")
  end

  private

  def build_uri
    uri = URI('https://api.nasa.gov/planetary/apod')
    required_params = {api_key: ENV['API_KEY']}
    uri.query = URI.encode_www_form(required_params)
    uri
  end

  def make_api_request
    self.api_response = JSON.parse(Net::HTTP.get(build_uri))
    if self.api_response['media_type'] == 'image'
      [self.api_response['hdurl'], self.api_response['title']]
    else
      "The response for #{self.api_response['date']} is a #{self.api_response['media_type']}, not an image."
    end
  end

end

apod = NasaApodApi.new
nasa_response = apod.get_image_uri
apod.download_image(nasa_response[0], nasa_response[1].gsub(' ', '-'))
