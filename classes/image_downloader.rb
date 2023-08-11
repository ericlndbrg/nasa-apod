# frozen_string_literal: true

# downloads each APOD image
class ImageDownloader
  def initialize(apod_data)
    self.apod_data = apod_data
  end

  def download_images
    path_to_images_directory = File.realdirpath('images')

    output_file_path = "#{path_to_images_directory}/#{apod_data['date']} #{replace_unpermitted_chars(apod_data['title'])}"
    image_url = apod_data['hdurl'] || apod_data['url']

    system('wget', "--output-document=#{output_file_path}", image_url)
  end

  private

  attr_accessor :apod_data

  def replace_unpermitted_chars(string)
    # add an array of unpermitted chars if more are discovered
    string.gsub('/', '-')
  end
end
