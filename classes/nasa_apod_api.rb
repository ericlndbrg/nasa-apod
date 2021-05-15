class NasaApodApi

  require 'net/http'
  require 'json'
  require 'open3'
  
  attr_accessor :api_response
  
  def fetch_image_uri_and_title
    uri = URI("https://api.nasa.gov/planetary/apod?api_key=#{ENV['API_KEY']}")
    request = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
    self.api_response = JSON.parse(response.body)
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

end
