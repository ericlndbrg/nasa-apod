require 'date'
require_relative 'image_downloader'
require_relative 'apod_datum'

class Application
  attr_reader :date, :apod_for_date

  def initialize
    @date = ARGF.argv[0] || Date.today.to_s
    @apod_for_date = ApodDatum.new(self.date)
  end

  def run
    # self.date's APOD can be either an image or a video
    # since I only care about images, check its media_type and decide what to do
    if self.apod_for_date.media_type == 'image'
      # self.date's APOD is an image
      if self.apod_for_date.downloaded == 0
        # I haven't downloaded it yet, download it
        download_image
        # mark self.date's APOD record as having been downloaded
        self.apod_for_date.mark_as_downloaded
      else
        # I've already downloaded it
        raise(StandardError, "APOD for #{self.date} has already been downloaded.")
      end
    else
      # self.date's APOD is not an image
      raise(StandardError, "APOD for #{self.date} is not an image.")
    end
  end

  private

  def download_image
    image_directory = File.realdirpath('images')
    image_url = self.apod_for_date.hdurl || self.apod_for_date.url
    ImageDownloader.download_image(image_url, self.apod_for_date.title, image_directory)
  end
end
