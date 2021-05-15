class NasaApodApi

  require 'net/http'
  require 'json'
  
  attr_accessor :api_response, :hdurl, :title
  
  def fetch_nasa_apod_response
    uri = URI("https://api.nasa.gov/planetary/apod?api_key=#{ENV['API_KEY']}")
    request = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
    self.api_response = JSON.parse(response.body)
    self.hdurl = self.api_response['hdurl']
    self.title = self.api_response['title']
    return [self.hdurl, build_image_filename]
  end

  private

  def build_image_filename
    image_extension = self.hdurl[self.hdurl.rindex('.'), self.hdurl.length]
    title_without_spaces = self.title.gsub(' ', '-')
    image_filename = "#{title_without_spaces}#{image_extension}"
    image_filename
  end

end
