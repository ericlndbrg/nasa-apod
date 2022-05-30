require_relative 'image_downloader'
require_relative 'nasa_apod_api'

class Application
  attr_reader :dates

  def initialize(dates)
    @dates = dates
  end

  def run
    apod_data = get_apod_data_from_nasa
    download_images(apod_data) unless apod_data.empty?
  end

  private

  def get_apod_data_from_nasa
    nasa_apod_api = NasaApodApi.new(self.dates)
    nasa_apod_api.fetch_apod_data
  end

  def download_images(apod_data)
    image_downloader = ImageDownloader.new(apod_data)
    image_downloader.download_images
  end
end
