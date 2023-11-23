# frozen_string_literal: true

# handles the APOD image downloading
class ImageDownloader
  APOD_IMAGE_DIRECTORY = File.absolute_path('images')

  def initialize(apod_metadata)
    self.apod_metadata = apod_metadata
  end

  def download_image
    image_title = "#{apod_metadata['date']} #{replace_unpermitted_chars(apod_metadata['title'])}"
    output_file_path = "#{APOD_IMAGE_DIRECTORY}/#{image_title}"
    image_url = apod_metadata['hdurl'] || apod_metadata['url']

    system('wget', "--output-document=#{output_file_path}", image_url)
  end

  private

  attr_accessor :apod_metadata

  def replace_unpermitted_chars(string)
    # add an array of unpermitted chars if more are discovered
    string.gsub('/', '-')
  end
end
