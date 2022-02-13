class NasaApodApi
  require 'net/http'
  require 'json'

  attr_accessor :base_url, :api_response, :image_url, :image_filename

  def initialize
    self.base_url = URI("https://api.nasa.gov/planetary/apod?api_key=#{ENV['API_KEY']}")
  end

  def fetch_apod_image_url_and_filename
    fetch_nasa_apod_data

    # only download the images
    unless self.api_response['media_type'] == 'image'
      raise(StandardError, 'Today\'s APOD is not an image.')
    end

    # use url if there is no hdurl in self.api_response
    if self.api_response.has_key?('hdurl')
      self.image_url = self.api_response['hdurl']
    else
      self.image_url = self.api_response['url']
    end

    # this will be the name of the downloaded image file
    # used to check if today's APOD has already been downloaded
    self.image_filename = build_image_filename(self.api_response['title'])
  end

  private

  def fetch_nasa_apod_data
    response = Net::HTTP.get(self.base_url)
    self.api_response = JSON.parse(response)
  end

  def build_image_filename(image_title)
    image_extension = self.image_url[
      self.image_url.rindex('.'),
      self.image_url.length
    ]
    title_without_spaces = image_title.gsub(' ', '-')
    image_filename = "#{title_without_spaces}#{image_extension}"
  end
end
