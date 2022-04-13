require 'date'
require_relative 'image_downloader'
require_relative 'apod_datum'

class Application
  attr_reader :today, :apod_for_today

  def initialize
    @today = Date.today.to_s
    @apod_for_today = ApodDatum.new(self.today)
  end

  def run
    # today's APOD can be either an image or a video
    # since I only care about images, check its media_type and decide what to do
    if self.apod_for_today.media_type == 'image'
      # today's APOD is an image
      if self.apod_for_today.downloaded == 0
        # I haven't downloaded it yet, download it
        download_image
        # mark today's APOD record as having been downloaded
        self.apod_for_today.mark_as_downloaded
      else
        # I've already downloaded it
        raise(StandardError, "APOD for #{self.today} has already been downloaded.")
      end
    else
      # today's APOD is not an image
      raise(StandardError, "APOD for #{self.today} is not an image.")
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
