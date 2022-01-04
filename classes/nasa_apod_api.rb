class NasaApodApi
  require 'net/http'
  require 'json'

  attr_accessor :api_response, :image_url, :image_filename

  def fetch_apod_image_url_and_filename
    fetch_nasa_apod_data
    raise StandardError unless self.api_response['media_type'] == 'image'
    self.image_url = self.api_response.has_key?('hdurl') ? self.api_response['hdurl'] : self.api_response['url']
    self.image_filename = build_image_filename(self.api_response['title'])
  end

  private

  def fetch_nasa_apod_data
    uri = URI("https://api.nasa.gov/planetary/apod?api_key=#{ENV['API_KEY']}")
    request = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
    self.api_response = JSON.parse(response.body)
  end

  def build_image_filename(image_title)
    image_extension = self.image_url[self.image_url.rindex('.'), self.image_url.length]
    title_without_spaces = image_title.gsub(' ', '-')
    image_filename = "#{title_without_spaces}#{image_extension}"
  end
end
