# frozen_string_literal: true

# downloads each APOD image
class ImageDownloader
  def initialize(apod_data)
    @apod_data = apod_data
  end

  def download_images
    path_to_images_directory = File.realdirpath('images')
    self.apod_data.each do |apod|
      next if apod['media_type'] != 'image'

      output_file_path = "#{path_to_images_directory}/#{apod['title']}"
      image_url = apod['hdurl'] || apod['url']
      system('wget', "--output-document=#{output_file_path}", '--no-clobber', image_url)
    end
  end

  private

  attr_reader :apod_data
end
