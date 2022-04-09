require 'date'
require_relative 'image_downloader'
require_relative 'apod_datum'

class Application
  attr_reader :today, :apod_for_today

  def initialize
    @today = Date.today.to_s
    @apod_for_today = ApodDatum.find_or_create(self.today)
  end

  def run
    if self.apod_for_today.media_type == 'image'
      if self.apod_for_today.downloaded == 0
        download_image
        self.apod_for_today.update
      else
        raise(StandardError, "APOD for #{today} has already been downloaded.")
      end
    else
      raise(StandardError, "APOD for #{today} is not an image.")
    end
  rescue StandardError => e
    puts e.message
  end

  private

  def download_image
    image_directory = File.realdirpath('images')
    image_url = self.apod_for_today.hdurl || self.apod_for_today.url
    ImageDownloader.download_image(image_url, self.apod_for_today.title, image_directory)
  end
end
