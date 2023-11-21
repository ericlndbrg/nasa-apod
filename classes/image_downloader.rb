# frozen_string_literal: true

# handles the APOD image downloading
class ImageDownloader
  def initialize(apod_metadata)
    self.apod_metadata = apod_metadata
  end

  def download_image
    path_to_images_directory = File.realdirpath('images')
    image_title = "#{apod_metadata['date']} #{replace_unpermitted_chars(apod_metadata['title'])}"
    output_file_path = "#{path_to_images_directory}/#{image_title}"
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
