class NasaApodApi

  require 'net/http'
  require 'json'
  require 'open3'
  
  attr_accessor :api_response
  
  def get_image_uri
    self.api_response = JSON.parse(Net::HTTP.get(build_uri))
    if self.api_response['media_type'] == 'image'
      {
        hdurl: self.api_response['hdurl'],
        title: self.api_response['title'].gsub(' ', '-')
      }
    else
      puts "The response for #{self.api_response['date']} is a #{self.api_response['media_type']}, not an image."
    end
  end

  def download_image(uri, title, date)
    image_extension = uri[uri.rindex('.'), uri.length]
    modified_title = title.prepend(date, ':')
    stdout, stderr, status = Open3.capture3("wget --output-document=./images/#{modified_title}#{image_extension} #{uri}")
  end

  private

  def build_uri
    uri = URI('https://api.nasa.gov/planetary/apod')
    required_params = {api_key: ENV['API_KEY']}
    uri.query = URI.encode_www_form(required_params)
    uri
  end

end
